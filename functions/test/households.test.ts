import { Client } from "pg";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { sha256Hex } from "../src/lib/ids";
import { testApp, token, VERSION_HEADERS } from "./helpers";

// FR-7 end to end through the gateway, against the local database (ADR-0018).
const ADMIN_URL = "postgres://postgres:postgres@127.0.0.1:54322/postgres";
const ANN = "0192f3c4-0000-7000-8000-0000000fa001";
const BOB = "0192f3c4-0000-7000-8000-0000000fb002";
const CAT = "0192f3c4-0000-7000-8000-0000000fc003";

const admin = new Client({ connectionString: ADMIN_URL });
admin.on("error", () => undefined);
const call = testApp();
const created: string[] = [];

beforeAll(async () => {
  await admin.connect();
  await admin.query(
    `insert into auth.users (id, email) values ($1, 'ann.fr7@example.test'), ($2, 'bob.fr7@example.test'),
     ($3, 'cat.fr7@example.test') on conflict (id) do nothing`,
    [ANN, BOB, CAT],
  );
});

afterAll(async () => {
  if (created.length > 0) {
    await admin.query("delete from public.households where id = any($1::uuid[])", [created]);
  }
  await admin.query("delete from auth.users where id in ($1, $2, $3)", [ANN, BOB, CAT]);
  await admin.end();
});

async function as(user: string, method: string, path: string, body?: unknown) {
  const res = await call(path, {
    method,
    headers: {
      ...VERSION_HEADERS,
      Authorization: `Bearer ${await token({ sub: user })}`,
      "Content-Type": "application/json",
    },
    ...(body === undefined ? {} : { body: JSON.stringify(body) }),
  });
  const text = await res.text();
  return { status: res.status, body: text ? (JSON.parse(text) as Record<string, unknown>) : {} };
}

const householdNames = async (user: string) =>
  ((await as(user, "GET", "/households")).body.households as { name: string }[]).map((h) => h.name);

describe("households and invites (FR-7)", () => {
  let home = "";
  let code = "";

  it("creates a household with the caller as its first member", async () => {
    const res = await as(ANN, "POST", "/households", {
      name: "Ann home",
      display_name: "Ann",
      hemisphere: "south",
    });

    expect(res.status).toBe(201);
    expect(res.body).toMatchObject({
      name: "Ann home",
      hemisphere: "south",
      public_cards_enabled: false,
    });
    home = res.body.id as string;
    created.push(home);
    expect(home).toMatch(/^[0-9a-f]{8}-[0-9a-f]{4}-7/); // UUID v7
    expect(await householdNames(ANN)).toEqual(["Ann home"]);
  });

  it("creates an invite: a 12-character code shown once, only its hash stored", async () => {
    const res = await as(ANN, "POST", "/invites", { household_id: home });

    expect(res.status).toBe(201);
    code = res.body.code as string;
    expect(code).toMatch(/^[0-9A-Za-z]{12}$/);
    expect(res.body.url).toBe(`https://plants.pampait.pl/i/${code}`);
    const days = (Date.parse(res.body.expires_at as string) - Date.now()) / 86_400_000;
    expect(days).toBeGreaterThan(6.99);
    expect(days).toBeLessThanOrEqual(7);

    const stored = await admin.query<{ code_hash: string }>(
      "select code_hash from public.invites where household_id = $1",
      [home],
    );
    expect(stored.rows.map((r) => r.code_hash)).toEqual([await sha256Hex(code)]);
  });

  it("refuses to create an invite for someone else's household (404)", async () => {
    const res = await as(BOB, "POST", "/invites", { household_id: home });

    expect(res.status).toBe(404);
  });

  it("lets a new member join with the code", async () => {
    const res = await as(BOB, "POST", "/invites/accept", { code, display_name: "Bob" });

    expect(res.status).toBe(200);
    expect(res.body).toMatchObject({ id: home, name: "Ann home" });
    expect(await householdNames(BOB)).toEqual(["Ann home"]);
  });

  it("refuses a used code and an unknown code alike (404)", async () => {
    const used = await as(CAT, "POST", "/invites/accept", { code, display_name: "Cat" });
    const unknown = await as(CAT, "POST", "/invites/accept", {
      code: "AAAAAAAAAAAA",
      display_name: "Cat",
    });

    expect(used.status).toBe(404);
    expect(unknown.status).toBe(404);
    expect(used.body.type).toBe(unknown.body.type);
    expect(await householdNames(CAT)).toEqual([]);
  });

  it("lets a member leave", async () => {
    const res = await as(BOB, "POST", `/households/${home}/leave`, {
      confirm_delete_household: false,
    });

    expect(res.status).toBe(204);
    expect(await householdNames(BOB)).toEqual([]);
  });

  it("answers 404 when a non-member tries to leave", async () => {
    const res = await as(CAT, "POST", `/households/${home}/leave`, {
      confirm_delete_household: true,
    });

    expect(res.status).toBe(404);
  });

  it("asks the last member to confirm, then deletes the household", async () => {
    const unconfirmed = await as(ANN, "POST", `/households/${home}/leave`, {
      confirm_delete_household: false,
    });
    expect(unconfirmed.status).toBe(409);
    expect(unconfirmed.body.type).toBe("confirmation_required");
    expect(await householdNames(ANN)).toEqual(["Ann home"]);

    const confirmed = await as(ANN, "POST", `/households/${home}/leave`, {
      confirm_delete_household: true,
    });
    expect(confirmed.status).toBe(204);
    expect(await householdNames(ANN)).toEqual([]);
  });
});

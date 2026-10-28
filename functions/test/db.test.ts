import { Client } from "pg";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { createDbVersionPolicy } from "../src/db/version-policy";
import { authHeaders, envWithoutDatabase, testApp, token, VERSION_HEADERS } from "./helpers";

// Integration tests against the local Supabase stack (`npm run db:start` in
// the repo root; CI starts it too). The superuser connection only seeds and
// cleans up; every request under test goes through the Worker as
// plantnfc_api over the HYPERDRIVE binding (ADR-0017).
const ADMIN_URL = "postgres://postgres:postgres@127.0.0.1:54322/postgres";
const API_ROLE_URL = "postgres://plantnfc_api:local-dev-only@127.0.0.1:54322/postgres";

const ANN = "0192f3c4-0000-7000-8000-00000000a001";
const BOB = "0192f3c4-0000-7000-8000-00000000b002";
const CAT = "0192f3c4-0000-7000-8000-00000000c003"; // no household
const ANN_HOME = "0192f3c4-0000-7000-8000-0000000000aa";
const BOB_HOME = "0192f3c4-0000-7000-8000-0000000000bb";

const admin = new Client({ connectionString: ADMIN_URL });
// Late "socket closed" errors after end() must not become unhandled (see withDb).
admin.on("error", () => undefined);
const sql = (text: string, params: unknown[] = []) => admin.query(text, params);

beforeAll(async () => {
  await admin.connect();
  await sql(
    `insert into auth.users (id, email) values ($1, 'ann@example.test'), ($2, 'bob@example.test'), ($3, 'cat@example.test')
     on conflict (id) do nothing`,
    [ANN, BOB, CAT],
  );
  await sql(
    `insert into public.households (id, name) values ($1, 'Ann home'), ($2, 'Bob home')
     on conflict (id) do nothing`,
    [ANN_HOME, BOB_HOME],
  );
  await sql(
    `insert into public.household_members (household_id, user_id, display_name)
     values ($1, $2, 'Ann'), ($3, $4, 'Bob') on conflict do nothing`,
    [ANN_HOME, ANN, BOB_HOME, BOB],
  );
});

afterAll(async () => {
  await sql("delete from public.households where id in ($1, $2)", [ANN_HOME, BOB_HOME]);
  await sql("delete from auth.users where id in ($1, $2, $3)", [ANN, BOB, CAT]);
  await admin.end();
});

const call = testApp();
async function householdsOf(userId: string) {
  const res = await call("/households", {
    headers: { ...VERSION_HEADERS, Authorization: `Bearer ${await token({ sub: userId })}` },
  });
  return {
    status: res.status,
    body: await res.json<{ households: { id: string; name: string }[] }>(),
  };
}

describe("GET /v1/households through Hyperdrive, as the user (RLS)", () => {
  it("returns only the caller's household", async () => {
    const ann = await householdsOf(ANN);
    const bob = await householdsOf(BOB);

    expect(ann.status).toBe(200);
    expect(ann.body.households.map((h) => h.name)).toEqual(["Ann home"]);
    expect(bob.body.households.map((h) => h.name)).toEqual(["Bob home"]);
  });

  it("returns an empty list for a user without a household", async () => {
    const cat = await householdsOf(CAT);

    expect(cat.status).toBe(200);
    expect(cat.body.households).toEqual([]);
  });

  it("serialises rows exactly as the contract says (timestamps as strings)", async () => {
    const ann = await householdsOf(ANN);
    const [home] = ann.body.households as unknown as Record<string, unknown>[];

    expect(home).toMatchObject({ id: ANN_HOME, public_cards_enabled: false, hemisphere: "north" });
    expect(typeof home?.created_at).toBe("string");
  });

  it("answers 503 when the environment has no database", async () => {
    const res = await testApp(
      {},
      {},
      envWithoutDatabase(),
    )("/households", {
      headers: await authHeaders(),
    });

    expect(res.status).toBe(503);
    expect(res.headers.get("retry-after")).toBe("5");
  });
});

describe("the plantnfc_api login", () => {
  const api = new Client({ connectionString: API_ROLE_URL });
  api.on("error", () => undefined);
  beforeAll(() => api.connect());
  afterAll(() => api.end());

  it("cannot become service_role or postgres", async () => {
    await expect(api.query("set role service_role")).rejects.toThrow(/permission denied/);
    await expect(api.query("set role postgres")).rejects.toThrow(/permission denied/);
  });

  it("cannot read household data without acting for a user", async () => {
    await expect(api.query("select 1 from public.plants")).rejects.toThrow(/permission denied/);
  });

  it("resets the user context after each transaction (no leak between requests)", async () => {
    await api.query("begin");
    await api.query(
      "select set_config('request.jwt.claims', $1, true), set_config('role', 'authenticated', true)",
      [JSON.stringify({ sub: ANN })],
    );
    await api.query("commit");
    const { rows } = await api.query<{ role: string; claims: string | null }>(
      "select current_user as role, current_setting('request.jwt.claims', true) as claims",
    );

    expect(rows[0]?.role).toBe("plantnfc_api");
    expect(rows[0]?.claims ?? "").toBe("");
  });
});

describe("version policy from client_versions", () => {
  afterAll(async () => {
    await sql("update public.client_versions set min_version = '0.1.0' where platform = 'android'");
  });

  it("reads the minimum from the database, so it changes without a deploy", async () => {
    await sql("update public.client_versions set min_version = '0.2.0' where platform = 'android'");
    const policy = createDbVersionPolicy(0);
    const strict = testApp({ versionPolicy: policy });

    const old = await strict("/config", { headers: VERSION_HEADERS });
    const current = await strict("/config", {
      headers: { ...VERSION_HEADERS, "X-App-Version": "0.2.0" },
    });

    expect(old.status).toBe(426);
    expect(current.status).toBe(200);
    expect(await current.json()).toMatchObject({ min_version: "0.2.0" });
  });

  it("falls back to the Worker variables when the database is unavailable", async () => {
    const policy = createDbVersionPolicy(0);

    await expect(policy("android", envWithoutDatabase())).resolves.toEqual({
      min_version: "0.1.0",
      recommended_version: "0.1.0",
    });
  });
});

import { Client } from "pg";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import type { PullResponse, PushChange, PushResponse } from "../src/api/generated/types.gen";
import { uuidv7 } from "../src/lib/ids";
import { callerAs } from "./helpers";

// Sync end to end through the gateway, against the local database
// (AGENTS.md sections 5 and 10, ADR-0019).
const ADMIN_URL = "postgres://postgres:postgres@127.0.0.1:54322/postgres";
const ANN = "0192f3c4-0000-7000-8000-00000005a001";
const BOB = "0192f3c4-0000-7000-8000-00000005b002";
const CAT = "0192f3c4-0000-7000-8000-00000005c003";

const admin = new Client({ connectionString: ADMIN_URL });
admin.on("error", () => undefined);
const as = callerAs();

let home = ""; // Ann and Bob
let other = ""; // Cat

beforeAll(async () => {
  await admin.connect();
  await admin.query(
    `insert into auth.users (id, email) values ($1, 'ann.sync@example.test'),
     ($2, 'bob.sync@example.test'), ($3, 'cat.sync@example.test') on conflict (id) do nothing`,
    [ANN, BOB, CAT],
  );
  home = (await as(ANN, "POST", "/households", { name: "Home", display_name: "Ann" })).body
    .id as string;
  other = (await as(CAT, "POST", "/households", { name: "Cat", display_name: "Cat" })).body
    .id as string;
  const invite = await as(ANN, "POST", "/invites", { household_id: home });
  await as(BOB, "POST", "/invites/accept", { code: invite.body.code, display_name: "Bob" });
});

afterAll(async () => {
  await admin.query("delete from public.households where id = any($1::uuid[])", [[home, other]]);
  await admin.query("delete from auth.users where id in ($1, $2, $3)", [ANN, BOB, CAT]);
  await admin.end();
});

type Change = Omit<PushChange, "change_id"> & { change_id?: string };

/** Pushes [changes] as [user]; each gets a fresh change id unless given. */
async function push(user: string, changes: Change[], key = uuidv7(), household = home) {
  const res = await as(
    user,
    "POST",
    "/sync/push",
    { household_id: household, changes: changes.map((c) => ({ change_id: uuidv7(), ...c })) },
    { "Idempotency-Key": key },
  );
  const body = res.body as unknown as PushResponse;
  return {
    status: res.status,
    body,
    statuses: res.status === 200 ? body.results.map((r) => r.status) : [],
  };
}

async function pull(user: string, cursor?: string, household = home) {
  const query = `household_id=${household}${cursor ? `&cursor=${cursor}` : ""}`;
  const res = await as(user, "GET", `/sync/pull?${query}`);
  return { status: res.status, body: res.body as unknown as PullResponse };
}

const newPlant = (id: string, nickname: string): Change => ({
  entity: "plant",
  op: "upsert",
  id,
  plant: { nickname, preset_id: "monstera" },
});

const watering = (id: string, plantId: string, at = new Date().toISOString()): Change => ({
  entity: "watering_event",
  op: "upsert",
  id,
  watering_event: { plant_id: plantId, watered_at: at, source: "scan" },
});

const plantIn = async (user: string, id: string) =>
  (await pull(user)).body.plants.find((p) => p.id === id);

describe("push and pull (FR-2, NFR Offline)", () => {
  it("applies a new plant and its watering, and pulls them on another device", async () => {
    const plant = uuidv7();
    const event = uuidv7();
    const res = await push(ANN, [newPlant(plant, "Monty"), watering(event, plant)]);

    expect(res.status).toBe(200);
    expect(res.statuses).toEqual(["applied", "applied"]);

    const pulled = await pull(BOB);
    expect(pulled.status).toBe(200);
    expect(pulled.body.household).toMatchObject({ id: home, name: "Home" });
    expect(pulled.body.members.map((m) => m.display_name).sort()).toEqual(["Ann", "Bob"]);
    expect(pulled.body.plants.find((p) => p.id === plant)).toMatchObject({
      nickname: "Monty",
      preset_id: "monstera",
      room: null,
    });
    expect(pulled.body.watering_events.find((w) => w.id === event)).toMatchObject({
      plant_id: plant,
      user_id: ANN,
      source: "scan",
      deleted_at: null,
    });
  });

  it("is safe to retry: same key gives the original results, a new key reports duplicates", async () => {
    const plant = uuidv7();
    const changes = [{ ...newPlant(plant, "Fern"), change_id: uuidv7() }];
    const key = uuidv7();

    expect((await push(ANN, changes, key)).statuses).toEqual(["applied"]);
    expect((await push(ANN, changes, key)).statuses).toEqual(["applied"]);
    expect((await push(ANN, changes)).statuses).toEqual(["duplicate"]);
  });

  it("logs a watering once however often its id is sent", async () => {
    const plant = uuidv7();
    const event = uuidv7();
    await push(ANN, [newPlant(plant, "Pilea"), watering(event, plant)]);

    expect((await push(BOB, [watering(event, plant)])).statuses).toEqual(["duplicate"]);
    const events = (await pull(ANN)).body.watering_events.filter((w) => w.plant_id === plant);
    expect(events).toHaveLength(1);
  });

  it("returns only what changed since the cursor", async () => {
    const plant = uuidv7();
    await push(ANN, [newPlant(plant, "Calathea"), watering(uuidv7(), plant)]);
    const { cursor } = (await pull(BOB)).body;

    expect(cursor).toMatch(/^\d+$/);
    const quiet = (await pull(BOB, cursor)).body;
    expect(quiet.plants).toEqual([]);
    expect(quiet.watering_events).toEqual([]);
    expect(quiet.household.id).toBe(home);

    await push(ANN, [
      { entity: "plant", op: "upsert", id: plant, fields: ["room"], plant: { room: "Hall" } },
    ]);
    const delta = (await pull(BOB, cursor)).body;
    expect(delta.plants.map((p) => [p.id, p.room])).toEqual([[plant, "Hall"]]);
    expect(delta.watering_events).toEqual([]);
  });

  it("answers 404 for a household the caller isn't in", async () => {
    expect((await push(CAT, [newPlant(uuidv7(), "Intruder")])).status).toBe(404);
    expect((await pull(CAT)).status).toBe(404);
    expect((await pull(ANN, undefined, other)).status).toBe(404);
  });
});

describe("conflict rules (AGENTS.md section 5)", () => {
  it("merges offline edits to different fields: last write wins per field", async () => {
    const plant = uuidv7();
    await push(ANN, [newPlant(plant, "Monty")]);

    // Both edit offline, then reconnect in turn.
    await push(ANN, [
      { entity: "plant", op: "upsert", id: plant, fields: ["room"], plant: { room: "Kitchen" } },
    ]);
    await push(BOB, [
      {
        entity: "plant",
        op: "upsert",
        id: plant,
        fields: ["nickname"],
        plant: { nickname: "Big Monty" },
      },
    ]);

    expect(await plantIn(ANN, plant)).toMatchObject({ nickname: "Big Monty", room: "Kitchen" });
  });

  it("lets the later write win on the same field, and clears a listed field that's absent", async () => {
    const plant = uuidv7();
    await push(ANN, [newPlant(plant, "Monty")]);
    await push(ANN, [
      { entity: "plant", op: "upsert", id: plant, fields: ["room"], plant: { room: "Kitchen" } },
    ]);
    await push(BOB, [
      { entity: "plant", op: "upsert", id: plant, fields: ["room"], plant: { room: "Office" } },
    ]);
    expect((await plantIn(ANN, plant))?.room).toBe("Office");

    await push(ANN, [{ entity: "plant", op: "upsert", id: plant, fields: ["room"], plant: {} }]);
    expect(await plantIn(ANN, plant)).toMatchObject({ room: null, nickname: "Monty" });
  });

  it("keeps both waterings when two people water offline, and syncs an undo", async () => {
    const plant = uuidv7();
    const first = uuidv7();
    const second = uuidv7();
    await push(ANN, [newPlant(plant, "Ivy")]);

    await push(ANN, [watering(first, plant, "2026-10-28T07:00:00.000Z")]);
    await push(BOB, [watering(second, plant, "2026-10-28T07:05:00.000Z")]);
    expect(
      (await push(BOB, [{ entity: "watering_event", op: "delete", id: second }])).statuses,
    ).toEqual(["applied"]);

    const events = (await pull(ANN)).body.watering_events.filter((w) => w.plant_id === plant);
    expect(events.map((w) => [w.user_id, w.deleted_at === null]).sort()).toEqual([
      [ANN, true],
      [BOB, false],
    ]);
  });

  it("doesn't let a phone with its clock ahead log a watering in the future", async () => {
    const plant = uuidv7();
    const event = uuidv7();
    await push(ANN, [newPlant(plant, "Palm"), watering(event, plant, "2030-01-01T00:00:00.000Z")]);

    const logged = (await pull(ANN)).body.watering_events.find((w) => w.id === event);
    expect(Date.parse(logged?.watered_at ?? "")).toBeLessThanOrEqual(Date.now() + 1000);
  });

  it("soft-deletes a plant, frees its tag, and refuses later edits", async () => {
    const plant = uuidv7();
    const tag = uuidv7();
    await push(ANN, [
      newPlant(plant, "Cactus"),
      {
        entity: "tag",
        op: "upsert",
        id: tag,
        tag: { token: "Del0000000000000000000", plant_id: plant },
      },
    ]);
    await push(ANN, [{ entity: "plant", op: "delete", id: plant }]);

    const after = (await pull(BOB)).body;
    expect(after.plants.find((p) => p.id === plant)?.deleted_at).not.toBeNull();
    expect(after.tags.find((t) => t.id === tag)?.plant_id).toBeNull();

    const edit = await push(BOB, [
      { entity: "plant", op: "upsert", id: plant, fields: ["room"], plant: { room: "Bin" } },
    ]);
    expect(edit.body.results[0]?.problem?.type).toBe("not_found");
  });
});

describe("tags (FR-3, FR-6)", () => {
  it("records who wrote a tag, and moves a plant to its new tag when replaced", async () => {
    const plant = uuidv7();
    const oldTag = uuidv7();
    const newTag = uuidv7();
    const writtenAt = "2026-10-28T09:00:00.000Z";
    await push(ANN, [
      newPlant(plant, "Rubber"),
      {
        entity: "tag",
        op: "upsert",
        id: oldTag,
        tag: { token: "Old0000000000000000000", plant_id: plant },
      },
    ]);
    await push(BOB, [
      {
        entity: "tag",
        op: "upsert",
        id: newTag,
        tag: { token: "New0000000000000000000", plant_id: plant, written_at: writtenAt },
      },
    ]);

    const tags = (await pull(ANN)).body.tags;
    expect(tags.find((t) => t.id === oldTag)?.plant_id).toBeNull();
    expect(tags.find((t) => t.id === newTag)).toMatchObject({ plant_id: plant, written_by: BOB });
  });

  it("refuses a token that's already in use, without saying where", async () => {
    await push(
      CAT,
      [{ entity: "tag", op: "upsert", id: uuidv7(), tag: { token: "Cat0000000000000000000" } }],
      uuidv7(),
      other,
    );
    const res = await push(ANN, [
      { entity: "tag", op: "upsert", id: uuidv7(), tag: { token: "Cat0000000000000000000" } },
    ]);

    expect(res.body.results[0]?.problem).toEqual({
      type: "conflict",
      title: "The change conflicts with existing data",
      status: 409,
    });
  });

  it("frees a token as soon as its tag is deleted (ADR-0027)", async () => {
    const catTag = uuidv7();
    await push(
      CAT,
      [{ entity: "tag", op: "upsert", id: catTag, tag: { token: "Frd0000000000000000000" } }],
      uuidv7(),
      other,
    );
    await push(CAT, [{ entity: "tag", op: "delete", id: catTag }], uuidv7(), other);

    const res = await push(ANN, [
      { entity: "tag", op: "upsert", id: uuidv7(), tag: { token: "Frd0000000000000000000" } },
    ]);

    expect(res.statuses).toEqual(["applied"]);
  });

  it("refuses to change a tag's token", async () => {
    const tag = uuidv7();
    await push(ANN, [
      { entity: "tag", op: "upsert", id: tag, tag: { token: "Fix0000000000000000000" } },
    ]);
    const res = await push(ANN, [
      {
        entity: "tag",
        op: "upsert",
        id: tag,
        fields: ["token"],
        tag: { token: "Mov0000000000000000000" },
      },
    ]);

    expect(res.body.results[0]?.problem?.type).toBe("invalid_change");
  });
});

describe("rejections", () => {
  it("rejects bad changes one by one, applies the rest, and keeps each answer on retry", async () => {
    const plant = uuidv7();
    const otherPlant = uuidv7();
    await push(CAT, [newPlant(otherPlant, "Not yours")], uuidv7(), other);
    const changes: Change[] = [
      // A custom plant needs intervals, amount and method (FR-3).
      {
        change_id: uuidv7(),
        entity: "plant",
        op: "upsert",
        id: uuidv7(),
        plant: { nickname: "Odd" },
      },
      // A watering for another household's plant.
      { change_id: uuidv7(), ...watering(uuidv7(), otherPlant) },
      // A field sync can't set.
      {
        change_id: uuidv7(),
        entity: "plant",
        op: "upsert",
        id: uuidv7(),
        fields: ["household_id"],
        plant: {},
      },
      // The wrong patch for the entity.
      { change_id: uuidv7(), entity: "tag", op: "upsert", id: uuidv7(), plant: { nickname: "x" } },
      // A photo outside this plant's folder.
      {
        change_id: uuidv7(),
        entity: "plant",
        op: "upsert",
        id: plant,
        plant: {
          nickname: "Snap",
          preset_id: "monstera",
          photo_path: `${other}/${otherPlant}/${uuidv7()}.jpg`,
        },
      },
      // Households can't be deleted through sync.
      { change_id: uuidv7(), entity: "household", op: "delete", id: home },
      { change_id: uuidv7(), ...newPlant(uuidv7(), "Fine") },
    ];

    const first = await push(ANN, changes);
    expect(first.body.results.map((r) => [r.status, r.problem?.type, r.problem?.status])).toEqual([
      ["rejected", "invalid_change", 422],
      ["rejected", "not_found", 404],
      ["rejected", "invalid_change", 422],
      ["rejected", "invalid_change", 422],
      ["rejected", "invalid_change", 422],
      ["rejected", "invalid_change", 422],
      ["applied", undefined, undefined],
    ]);

    const retried = await push(ANN, changes);
    expect(retried.statuses).toEqual([...Array<string>(6).fill("rejected"), "duplicate"]);
  });

  it("changes household settings, but only its own", async () => {
    const res = await push(ANN, [
      {
        entity: "household",
        op: "upsert",
        id: home,
        fields: ["hemisphere"],
        household: { hemisphere: "south" },
      },
      { entity: "household", op: "upsert", id: other, household: { name: "Mine now" } },
    ]);

    expect(res.statuses).toEqual(["applied", "rejected"]);
    expect((await pull(BOB)).body.household).toMatchObject({ hemisphere: "south", name: "Home" });
  });

  it("requires an Idempotency-Key", async () => {
    const res = await as(ANN, "POST", "/sync/push", {
      household_id: home,
      changes: [{ change_id: uuidv7(), ...newPlant(uuidv7(), "No key") }],
    });

    expect(res.status).toBe(400);
  });
});

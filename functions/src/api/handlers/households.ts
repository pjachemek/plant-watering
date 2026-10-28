import { asCaller, asUser, rows, withDb, type Db } from "../../db/client";
import { uuidv7 } from "../../lib/ids";
import type { CreateHouseholdRequest, LeaveHouseholdData } from "../generated/types.gen";
import { problem } from "../problem";
import { respond, type OperationHandler } from "../v1";

const HOUSEHOLD_COLUMNS =
  "id, name, public_cards_enabled, hemisphere, created_at, updated_at, deleted_at";

/** Reads one household as the user; RLS hides it from non-members. */
export async function readHousehold(db: Db, id: string) {
  const [household] = await rows(
    db,
    `select ${HOUSEHOLD_COLUMNS} from public.households where id = $1 and deleted_at is null`,
    [id],
  );
  return household;
}

/**
 * GET /v1/households: the caller's households (FR-7). Runs as the user, so
 * RLS alone decides which rows come back (ADR-0017).
 */
export const listHouseholds: OperationHandler = async (c) => {
  const households = await withDb(c.env, (db) =>
    asUser(db, c.get("user"), (tx) =>
      rows(
        tx,
        `select ${HOUSEHOLD_COLUMNS} from public.households
         where deleted_at is null order by created_at`,
      ),
    ),
  );
  return respond(c, { households });
};

/** POST /v1/households: create a household with the caller as first member (FR-7). */
export const createHousehold: OperationHandler = async (c) => {
  const body = c.get("input").body as CreateHouseholdRequest;
  const user = c.get("user");
  const household = await withDb(c.env, async (db) => {
    const id = uuidv7();
    await asCaller(db, user, (tx) =>
      tx.query("select private.create_household($1, $2, $3, $4)", [
        id,
        body.name,
        body.display_name,
        body.hemisphere ?? "north",
      ]),
    );
    return asUser(db, user, (tx) => readHousehold(tx, id));
  });
  return respond(c, household, 201);
};

/**
 * POST /v1/households/{household_id}/leave (FR-7). The last member must
 * confirm, and the household is then deleted.
 */
export const leaveHousehold: OperationHandler = async (c) => {
  const { household_id } = c.get("input").path as LeaveHouseholdData["path"];
  const { confirm_delete_household } = c.get("input").body as LeaveHouseholdData["body"];
  const [result] = await withDb(c.env, (db) =>
    asCaller(db, c.get("user"), (tx) =>
      rows<{ status: string }>(tx, "select private.leave_household($1, $2) as status", [
        household_id,
        confirm_delete_household,
      ]),
    ),
  );
  switch (result?.status) {
    case "left":
    case "deleted":
      return c.body(null, 204);
    case "confirmation_required":
      return problem(
        c,
        409,
        "confirmation_required",
        "You are the last member: confirm to delete the household",
      );
    default:
      return problem(c, 404, "not_found", "Not found");
  }
};

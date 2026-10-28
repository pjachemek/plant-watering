import { asUser, rows, withDb } from "../../db/client";
import { respond, type OperationHandler } from "../v1";

/**
 * GET /v1/households: the caller's households (FR-7). Runs as the user, so
 * RLS alone decides which rows come back (ADR-0017).
 */
export const listHouseholds: OperationHandler = async (c) => {
  const households = await withDb(c.env, (db) =>
    asUser(db, c.get("user"), (tx) =>
      rows(
        tx,
        `select id, name, public_cards_enabled, hemisphere, created_at, updated_at, deleted_at
         from public.households
         where deleted_at is null
         order by created_at`,
      ),
    ),
  );
  return respond(c, { households });
};

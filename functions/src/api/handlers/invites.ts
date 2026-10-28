import { asCaller, asUser, isPermissionDenied, rows, withDb } from "../../db/client";
import { randomBase62, sha256Hex } from "../../lib/ids";
import type { AcceptInviteRequest, CreateInviteData } from "../generated/types.gen";
import { problem } from "../problem";
import { respond, type OperationHandler } from "../v1";
import { readHousehold } from "./households";
import { signalChanged } from "./live";

/** 12 base62 characters: about 71 bits, single use, 7 days, rate-limited. */
const CODE_LENGTH = 12;
const LIFETIME_MS = 7 * 24 * 60 * 60 * 1000;

/** Opened by the app (or the web page for people without it) to join. */
const INVITE_BASE_URL = "https://plants.pampait.pl/i/";

/**
 * POST /v1/invites (FR-7). Members only: the insert runs as the user, so RLS
 * refuses anyone else, which is reported as 404 like any household the
 * caller can't see. Only the code's SHA-256 is stored; the code is shown once.
 */
export const createInvite: OperationHandler = async (c) => {
  const { household_id } = c.get("input").body as CreateInviteData["body"];
  const user = c.get("user");
  const code = randomBase62(CODE_LENGTH);
  const codeHash = await sha256Hex(code);
  const expiresAt = new Date(Date.now() + LIFETIME_MS);

  try {
    await withDb(c.env, (db) =>
      asUser(db, user, (tx) =>
        tx.query(
          `insert into public.invites (household_id, code_hash, created_by, expires_at)
           values ($1, $2, $3, $4)`,
          [household_id, codeHash, user.id, expiresAt],
        ),
      ),
    );
  } catch (error) {
    if (isPermissionDenied(error)) return problem(c, 404, "not_found", "Not found");
    throw error;
  }
  return respond(c, { code, url: `${INVITE_BASE_URL}${code}`, expires_at: expiresAt }, 201);
};

/**
 * POST /v1/invites/accept (FR-7). Unknown, used and expired codes all answer
 * 404, so a guess reveals nothing.
 */
export const acceptInvite: OperationHandler = async (c) => {
  const body = c.get("input").body as AcceptInviteRequest;
  const user = c.get("user");
  const codeHash = await sha256Hex(body.code);

  const household = await withDb(c.env, async (db) => {
    const [joined] = await asCaller(db, user, (tx) =>
      rows<{ household_id: string | null }>(
        tx,
        "select private.accept_invite($1, $2) as household_id",
        [codeHash, body.display_name],
      ),
    );
    if (!joined?.household_id) return undefined;
    const id = joined.household_id;
    return asUser(db, user, (tx) => readHousehold(tx, id));
  });

  if (!household) return problem(c, 404, "not_found", "This invite is not valid");
  signalChanged(c, household.id as string);
  return respond(c, household);
};

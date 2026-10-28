import { Client, type QueryResultRow } from "pg";
import type { AuthUser } from "../api/auth";
import type { Bindings } from "../env";

/** A connected database client for one request. */
export type Db = Client;

/** Thrown when the Worker has no database binding (an environment without Hyperdrive). */
export class DatabaseUnavailable extends Error {
  override readonly name = "DatabaseUnavailable";
}

/**
 * Opens a Postgres client over Hyperdrive for one request, runs [work], and
 * closes the client. Hyperdrive pools the real connections, so a client per
 * request is what Cloudflare recommends (ADR-0017).
 */
export async function withDb<T>(env: Bindings, work: (db: Db) => Promise<T>): Promise<T> {
  const hyperdrive = env.HYPERDRIVE;
  if (!hyperdrive) throw new DatabaseUnavailable("No HYPERDRIVE binding");
  const db = new Client({ connectionString: hyperdrive.connectionString });
  // node-postgres requires an error listener on every client: without one, a
  // late socket error is thrown. Closing a Workers socket rejects its pending
  // read ("This socket has been closed"), which arrives after end(); that one
  // is expected. Any other client error is logged (no details: NFR Privacy).
  let ending = false;
  db.on("error", (error) => {
    if (!ending) console.error("db_client_error", error.name);
  });
  await db.connect();
  try {
    return await work(db);
  } finally {
    ending = true;
    await db.end();
  }
}

/**
 * Runs [work] in one transaction as the signed-in user: the verified claims
 * are set and the role switches to `authenticated`, so every RLS policy
 * applies (AGENTS.md section 6). Both settings end with the transaction, so
 * nothing leaks to the next request on a pooled connection.
 */
export async function asUser<T>(db: Db, user: AuthUser, work: (db: Db) => Promise<T>): Promise<T> {
  const claims = JSON.stringify({ sub: user.id, role: "authenticated" });
  await db.query("begin");
  try {
    await db.query(
      "select set_config('request.jwt.claims', $1, true), set_config('role', 'authenticated', true)",
      [claims],
    );
    const result = await work(db);
    await db.query("commit");
    return result;
  } catch (error) {
    await db.query("rollback").catch(() => undefined);
    throw error;
  }
}

/** Runs a parameterised query and returns its rows. */
export async function rows<R extends QueryResultRow>(
  db: Db,
  text: string,
  params: unknown[] = [],
): Promise<R[]> {
  return (await db.query<R>(text, params)).rows;
}

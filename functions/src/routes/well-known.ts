import { Hono } from "hono";
import appleAppSiteAssociation from "../../../web/.well-known/apple-app-site-association.json";
import assetLinks from "../../../web/.well-known/assetlinks.json";
import type { Bindings } from "../env";

/**
 * App-link association files (AGENTS.md section 6). Both must be served as
 * `application/json` with a 200 and no redirect, or the OS refuses to verify
 * the domain. The sources live in `web/.well-known/`.
 */
export const wellKnown = new Hono<{ Bindings: Bindings }>();

const headers = { "Cache-Control": "public, max-age=3600" };

wellKnown.get("/apple-app-site-association", (c) => c.json(appleAppSiteAssociation, 200, headers));

wellKnown.get("/assetlinks.json", (c) => c.json(assetLinks, 200, headers));

import { Hono } from "hono";
import type { Bindings } from "../env";

/** Invite codes: 12 base62 characters (ADR-0018). */
const CODE = /^[0-9A-Za-z]{12}$/;

/**
 * `/i/{code}`: household invite links (ADR-0018, ADR-0026). With the app
 * installed, Android opens the join screen instead (a verified App Link), so
 * this page is only seen in a browser. It never echoes or checks the code:
 * the code is only redeemed in the app, by a signed-in person. No scripts,
 * cookies or third-party requests; nothing is cached.
 */
export const invitePage = new Hono<{ Bindings: Bindings }>();

invitePage.get("/:code{[^/]+}", (c) => {
  if (!CODE.test(c.req.param("code"))) {
    return c.notFound();
  }
  return c.html(PAGE, 200, {
    "Cache-Control": "no-store",
    "X-Robots-Tag": "noindex, nofollow",
  });
});

const PAGE = `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="noindex, nofollow">
<title>Plant NFC invite</title>
<style>
:root{color-scheme:light dark;--bg:#f7fbf7;--fg:#181d1a;--muted:#424844;--accent:#2a6b4b}
@media (prefers-color-scheme:dark){:root{--bg:#101411;--fg:#dde5df;--muted:#c1c9c3;--accent:#a6d4b7}}
body{margin:0;background:var(--bg);color:var(--fg);font:1rem/1.5 system-ui,sans-serif}
main{max-width:36rem;margin:0 auto;padding:3rem 1rem;text-align:center}
h1{font-size:1.5rem;margin:0 0 .75rem}
p{color:var(--muted);margin:0 0 .75rem}
.leaf{font-size:3rem;color:var(--accent)}
</style>
</head>
<body>
<main>
<div class="leaf" aria-hidden="true">&#127793;</div>
<h1>You're invited to a Plant NFC household</h1>
<p>Open this link on your Android phone with the Plant NFC app installed, and sign in to join.</p>
<p>Or open the app, choose "Join with a code", and paste this link.</p>
</main>
</body>
</html>`;

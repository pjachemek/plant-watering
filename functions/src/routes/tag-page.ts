import { Hono } from "hono";
import type { Bindings } from "../env";

/** Same format as the app's TagToken: 22 base62 characters. */
const TOKEN = /^[0-9A-Za-z]{22}$/;

/**
 * `/p/{tagToken}` for phones without the app (M1 placeholder). The full
 * read-only care card arrives with FR-8 in M6. The page never echoes the
 * token and has no scripts, cookies or third-party requests.
 */
export const tagPage = new Hono<{ Bindings: Bindings }>();

tagPage.get("/:token{[^/]+}", (c) => {
  if (!TOKEN.test(c.req.param("token"))) {
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
<title>Plant NFC</title>
<style>
:root{color-scheme:light dark;--bg:#f7fbf7;--fg:#181d1a;--muted:#424844;--accent:#2a6b4b}
@media (prefers-color-scheme:dark){:root{--bg:#101411;--fg:#dde5df;--muted:#c1c9c3;--accent:#a6d4b7}}
body{margin:0;background:var(--bg);color:var(--fg);font:1rem/1.5 system-ui,sans-serif}
main{max-width:36rem;margin:0 auto;padding:3rem 1rem;text-align:center}
h1{font-size:1.5rem;margin:0 0 .75rem}
p{color:var(--muted);margin:0}
.leaf{font-size:3rem;color:var(--accent)}
</style>
</head>
<body>
<main>
<div class="leaf" aria-hidden="true">&#127793;</div>
<h1>This is a Plant NFC tag</h1>
<p>Open it with the Plant NFC app to see how and when to water this plant.</p>
</main>
</body>
</html>`;

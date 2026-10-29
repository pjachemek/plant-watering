import { Hono } from "hono";
import type { Bindings } from "../env";

/**
 * `/auth/callback` (ADR-0021): where email sign-in links point. On the phone
 * that asked for the link, Android opens the app instead (a verified App
 * Link), so this page is only seen in a browser: on a computer, or a phone
 * without the app. It never reads or echoes the one-time code, which is
 * useless without the code verifier kept on the phone. No scripts, cookies
 * or third-party requests; nothing is cached.
 */
export const authCallbackPage = new Hono<{ Bindings: Bindings }>();

authCallbackPage.get("/callback", (c) =>
  c.html(PAGE, 200, {
    "Cache-Control": "no-store",
    "X-Robots-Tag": "noindex, nofollow",
  }),
);

const PAGE = `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="noindex, nofollow">
<title>Plant NFC sign-in</title>
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
<h1>Open this link on your phone</h1>
<p>Sign-in links work only in the Plant NFC app, on the phone where you asked for the link.</p>
<p>Open the email on that phone and tap the link again. If it has expired, ask the app for a new one.</p>
</main>
</body>
</html>`;

import { secureHeaders } from "hono/secure-headers";

/**
 * Headers for every response on both hosts: HSTS, nosniff, no referrer and a
 * default-deny CSP (the web pages use no scripts or third-party resources).
 */
export const securityHeaders = secureHeaders({
  strictTransportSecurity: "max-age=63072000; includeSubDomains; preload",
  referrerPolicy: "no-referrer",
  contentSecurityPolicy: {
    defaultSrc: ["'none'"],
    styleSrc: ["'self'", "'unsafe-inline'"],
    imgSrc: ["'self'", "data:", "https:"],
    baseUri: ["'none'"],
    formAction: ["'none'"],
    frameAncestors: ["'none'"],
  },
});

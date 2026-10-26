import type { ErrorEvent } from "@sentry/cloudflare";

const SENSITIVE_KEYS = /token|email|name|authorization|cookie|photo|jwt|secret|key/i;
const EMAIL = /[^\s@]+@[^\s@]+\.[^\s@]+/g;
const TAG_PATH = /\/p\/[A-Za-z0-9]+/g;

function scrubString(value: string): string {
  return value.replace(EMAIL, "[email]").replace(TAG_PATH, "/p/[token]");
}

function scrubRecord(record: Record<string, unknown> | undefined): void {
  if (!record) return;
  for (const key of Object.keys(record)) {
    const value = record[key];
    if (SENSITIVE_KEYS.test(key)) {
      record[key] = "[redacted]";
    } else if (typeof value === "string") {
      record[key] = scrubString(value);
    }
  }
}

/**
 * Removes personal data before an event leaves the Worker (NFR Privacy:
 * no emails, names, tokens or photo URLs in logs and crash reports).
 */
export function scrubEvent(event: ErrorEvent): ErrorEvent {
  delete event.user;
  if (event.request) {
    delete event.request.cookies;
    delete event.request.data;
    scrubRecord(event.request.headers);
    if (event.request.url) event.request.url = scrubString(event.request.url);
    if (event.request.query_string) event.request.query_string = "[redacted]";
  }
  if (event.message) event.message = scrubString(event.message);
  for (const ex of event.exception?.values ?? []) {
    if (ex.value) ex.value = scrubString(ex.value);
  }
  scrubRecord(event.extra);
  return event;
}

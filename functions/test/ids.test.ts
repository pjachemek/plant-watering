import { describe, expect, it } from "vitest";
import { randomBase62, sha256Hex, uuidv7 } from "../src/lib/ids";

describe("uuidv7", () => {
  it("is a version 7, RFC 9562 variant UUID", () => {
    expect(uuidv7()).toMatch(
      /^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/,
    );
  });

  it("encodes the timestamp in the first 48 bits, so ids sort by time", () => {
    const at = Date.UTC(2026, 9, 28, 12, 0, 0);
    const id = uuidv7(at);

    expect(parseInt(id.replace(/-/g, "").slice(0, 12), 16)).toBe(at);
    expect(uuidv7(at) < uuidv7(at + 1)).toBe(true);
  });

  it("is unique", () => {
    const ids = new Set(Array.from({ length: 5000 }, () => uuidv7(0)));

    expect(ids.size).toBe(5000);
  });
});

describe("randomBase62", () => {
  it("has the requested length and alphabet", () => {
    for (const length of [1, 12, 40]) {
      expect(randomBase62(length)).toMatch(new RegExp(`^[0-9A-Za-z]{${String(length)}}$`));
    }
  });

  it("uses every character with roughly equal frequency", () => {
    const counts = new Map<string, number>();
    for (const ch of randomBase62(62_000)) counts.set(ch, (counts.get(ch) ?? 0) + 1);

    expect(counts.size).toBe(62);
    for (const n of counts.values()) {
      expect(n).toBeGreaterThan(700); // expected 1000 each
      expect(n).toBeLessThan(1300);
    }
  });
});

describe("sha256Hex", () => {
  it("matches the standard test vector", async () => {
    expect(await sha256Hex("abc")).toBe(
      "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
    );
  });
});

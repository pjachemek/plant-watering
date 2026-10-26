import { exports } from "cloudflare:workers";
import { describe, expect, it } from "vitest";
import appleAppSiteAssociation from "../../web/.well-known/apple-app-site-association.json";
import assetLinks from "../../web/.well-known/assetlinks.json";

const BASE = "https://plants.pampait.pl";

describe("app-link association files", () => {
  it("serves assetlinks.json as JSON without redirect", async () => {
    const res = await exports.default.fetch(`${BASE}/.well-known/assetlinks.json`, {
      redirect: "manual",
    });

    expect(res.status).toBe(200);
    expect(res.headers.get("content-type")).toMatch(/^application\/json/);
    expect(await res.json()).toEqual(assetLinks);
  });

  it("serves apple-app-site-association as JSON at the extensionless path", async () => {
    const res = await exports.default.fetch(`${BASE}/.well-known/apple-app-site-association`, {
      redirect: "manual",
    });

    expect(res.status).toBe(200);
    expect(res.headers.get("content-type")).toMatch(/^application\/json/);
    expect(await res.json()).toEqual(appleAppSiteAssociation);
  });

  it("assetlinks targets our package with SHA-256 fingerprints", () => {
    const [entry] = assetLinks;

    expect(entry?.relation).toContain("delegate_permission/common.handle_all_urls");
    expect(entry?.target.package_name).toBe("pl.pampait.plantnfc");
    expect(entry?.target.sha256_cert_fingerprints.length).toBeGreaterThan(0);
    for (const fp of entry?.target.sha256_cert_fingerprints ?? []) {
      expect(fp).toMatch(/^([0-9A-F]{2}:){31}[0-9A-F]{2}$/);
    }
  });
});

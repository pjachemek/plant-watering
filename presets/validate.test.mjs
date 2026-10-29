// node --test presets/validate.test.mjs
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { test } from "node:test";
import { appCopy, check, normalize } from "./validate.mjs";

const schema = JSON.parse(readFileSync(new URL("./presets.schema.json", import.meta.url)));
const real = JSON.parse(readFileSync(new URL("./presets.json", import.meta.url)));

/** A valid preset to break in each test. */
function preset(overrides = {}) {
  return {
    id: "pothos",
    common_name: "Pothos",
    latin_name: "Epipremnum aureum",
    aliases: [{ name: "Epipremnum złocisty", lang: "pl" }],
    interval_summer_days: 7,
    interval_winter_days: 12,
    method: "top",
    amount: { size: "medium", hint: "Until it drains" },
    soil_check: "Top 2 cm dry",
    light: "Medium to bright indirect light",
    tips: ["Drooping leaves mean it is thirsty."],
    pet_toxic: "yes",
    sources: [{ title: "Example", url: "https://example.org/pothos" }],
    ...overrides,
  };
}

const file = (...presets) => ({ version: 1, presets });

test("the real presets file is valid", () => {
  assert.deepEqual(check(real, schema), []);
});

test("a minimal valid file passes", () => {
  assert.deepEqual(check(file(preset()), schema), []);
});

test("the schema rejects missing fields, bad values and long text", () => {
  const { light: _, ...noLight } = preset();
  const cases = [
    noLight,
    preset({ interval_summer_days: 0 }),
    preset({ interval_winter_days: 61 }),
    preset({ method: "drip" }),
    preset({ pet_toxic: "maybe" }),
    preset({ id: "Pothos Plant" }),
    preset({ tips: ["a", "b", "c", "d"] }),
    preset({ tips: ["x".repeat(120)] }),
    preset({ sources: [] }),
    preset({ sources: [{ title: "Plain", url: "http://example.org" }] }),
    preset({ aliases: [{ name: "Złocisty", lang: "de" }] }),
    preset({ common_name: " Pothos" }),
    preset({ extra: true }),
  ];
  for (const bad of cases) {
    assert.notDeepEqual(check(file(bad), schema), [], JSON.stringify(bad).slice(0, 80));
  }
});

test("rules beyond the schema", () => {
  const problems = (data) => check(data, schema).join("\n");

  assert.match(problems(file(preset(), preset())), /duplicate id/);
  assert.match(problems(file(preset({ id: "zz" }), preset({ id: "aa" }))), /sorted by id/);
  assert.match(
    problems(file(preset({ interval_summer_days: 9, interval_winter_days: 7 }))),
    /winter interval is shorter/,
  );
  assert.match(
    problems(file(preset({ aliases: [{ name: "Devil's ivy", lang: "en" }] }))),
    /Polish alias/,
  );
  assert.match(
    problems(
      file(
        preset({ id: "a-pothos" }),
        preset({
          id: "b-other",
          common_name: "Other",
          latin_name: "Othera",
          aliases: [{ name: "EPIPREMNUM ZŁOCISTY", lang: "pl" }],
        }),
      ),
    ),
    /also a name of a-pothos/,
  );
  assert.match(
    problems(file(preset({ aliases: [{ name: "pothos", lang: "pl" }] }))),
    /listed twice/,
  );
});

test("names compare without accents, case or extra spaces", () => {
  assert.equal(normalize("  Skrzydłokwiat   Wallisa "), "skrzydlokwiat wallisa");
  assert.equal(normalize("Épipremnum ŁÓDŹ"), "epipremnum lodz");
});

test("the app copy is the compact file with a newline", () => {
  assert.equal(appCopy({ version: 1, presets: [] }), '{"version":1,"presets":[]}\n');
});

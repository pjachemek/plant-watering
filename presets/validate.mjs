// Validates presets/presets.json (AGENTS.md section 8, ADR-0028): the JSON
// Schema, then the rules a schema can't express. With --sync it also writes
// the app's bundled copy; without it, it fails when that copy is stale.
//
// Usage: node presets/validate.mjs [--sync]

import { readFileSync, writeFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import Ajv2020 from "ajv/dist/2020.js";
import addFormats from "ajv-formats";

const here = (path) => fileURLToPath(new URL(path, import.meta.url));
const SOURCE = here("./presets.json");
const SCHEMA = here("./presets.schema.json");
const APP_COPY = here("../app/assets/presets/presets.json");

/** Lower case, accents removed, spaces collapsed: how the app's search compares names. */
export function normalize(text) {
  return text
    .normalize("NFD")
    .replace(/\p{Diacritic}/gu, "")
    .replace(/ł/g, "l")
    .replace(/Ł/g, "L")
    .toLowerCase()
    .replace(/\s+/g, " ")
    .trim();
}

/** Every problem in [data], as readable messages; empty when valid. */
export function check(data, schema) {
  const ajv = new Ajv2020({ allErrors: true, strict: true });
  addFormats(ajv);
  const validate = ajv.compile(schema);
  if (!validate(data)) {
    return validate.errors.map((e) => `${e.instancePath || "/"} ${e.message}`);
  }

  const problems = [];
  const ids = new Set();
  const names = new Map(); // normalized name -> preset id
  let previous = "";
  for (const p of data.presets) {
    if (ids.has(p.id)) problems.push(`${p.id}: duplicate id`);
    ids.add(p.id);
    if (p.id < previous) problems.push(`${p.id}: presets must be sorted by id`);
    previous = p.id;

    if (p.interval_winter_days < p.interval_summer_days) {
      problems.push(`${p.id}: winter interval is shorter than summer`);
    }
    if (!p.aliases.some((a) => a.lang === "pl")) {
      problems.push(`${p.id}: needs at least one Polish alias`);
    }

    const own = new Set();
    for (const name of [p.common_name, p.latin_name, ...p.aliases.map((a) => a.name)]) {
      const key = normalize(name);
      if (own.has(key)) {
        // Repeating a name within one preset adds nothing to search.
        problems.push(`${p.id}: "${name}" is listed twice`);
        continue;
      }
      own.add(key);
      const other = names.get(key);
      if (other) problems.push(`${p.id}: "${name}" is also a name of ${other}`);
      else names.set(key, p.id);
    }
  }
  return problems;
}

/** The bundled copy as the app reads it: the source, compact. */
export function appCopy(data) {
  return `${JSON.stringify(data)}\n`;
}

function main() {
  const data = JSON.parse(readFileSync(SOURCE, "utf8"));
  const schema = JSON.parse(readFileSync(SCHEMA, "utf8"));
  const problems = check(data, schema);
  if (problems.length > 0) {
    console.error(`presets.json has ${problems.length} problem(s):`);
    for (const p of problems) console.error(`  - ${p}`);
    process.exit(1);
  }

  const expected = appCopy(data);
  if (process.argv.includes("--sync")) {
    writeFileSync(APP_COPY, expected);
    console.log(`presets v${data.version}: ${data.presets.length} valid; app copy written`);
    return;
  }
  let actual = "";
  try {
    actual = readFileSync(APP_COPY, "utf8");
  } catch {
    // Missing counts as stale.
  }
  if (actual !== expected) {
    console.error("app/assets/presets/presets.json is stale: run npm run presets:sync");
    process.exit(1);
  }
  console.log(`presets v${data.version}: ${data.presets.length} valid; app copy current`);
}

if (process.argv[1] === fileURLToPath(import.meta.url)) main();

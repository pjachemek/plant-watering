# ADR-0028: Preset file, schema and validator

- Status: Accepted
- Date: 2026-10-29
- Related: M3 increment 3.1; AGENTS.md sections 8 and 10; FR-3

## Context

The app ships a curated, versioned list of houseplant care presets, searched offline (AGENTS.md section 8). The brief fixes the fields, asks for a JSON Schema checked in CI, and rejects duplicates, missing fields and intervals outside 1–60 days. The product owner decided that names are English, with Polish aliases, and both are searchable.

## Decision

**One source file:** `presets/presets.json` = `{ "version": n, "presets": [...] }`.
- `version` is bumped with every change. Plants keep the version they were created from (`preset_version`), so an update never silently changes a plant.
- **Fields** follow section 8, with two structured where the brief left the shape open:
  - **`aliases`** are `{ name, lang }`, with `lang` `en` or `pl`. Search uses every name. A Polish interface (not decided yet) can show the Polish name without another change to the file.
  - **`amount`** is `{ size, hint }`: the size (small, medium, large) drives the UI; the hint is plain language.
- **`sources`** are `{ title, url }`, https only. The README asks for each link's page title to be checked: a guessed page ID pointed at the wrong plant while the first preset was being written.

**The schema** (`presets.schema.json`, JSON Schema 2020-12) checks:
- every required field, and nothing more (`additionalProperties: false`);
- ids as stable slugs (the same format as the database's `preset_id` check);
- intervals from 1 to 60 days;
- the allowed values (`method`, `size`, `pet_toxic`, `lang`);
- text lengths, including tips under 120 characters and at most 3 tips;
- no leading or trailing spaces;
- https links.

**The validator** (`validate.mjs`) runs the schema, then the rules a schema can't express:
- no duplicate ids;
- presets sorted by id (clean diffs);
- the winter interval is never shorter than the summer one;
- at least one Polish alias per preset;
- no name used by two presets, comparing names the way search does (without accents or case);
- no name repeated within one preset.

**The app's copy:**
- Flutter can't bundle files from outside `app/`, so `npm run presets:sync` validates and writes a compact copy to `app/assets/presets/presets.json`.
- `npm run presets:validate` (CI) fails when that copy is stale. The copy is never edited by hand.

**CI:** a `presets` job runs the validator's own tests (`node --test`) and the validation.

## Dependencies

At the repository root, dev only, pinned:

| Package | Use | Licence | Maintenance (2026-10-29) |
| --- | --- | --- | --- |
| `ajv` 8.20.0 | JSON Schema 2020-12 validation, in strict mode | MIT | The most-used JSON Schema validator for JavaScript; actively released |
| `ajv-formats` 3.0.1 | The `uri` format for source links | MIT | Companion package from the same maintainers |

`npm audit` reports no known vulnerabilities. The validator's tests use Node's built-in test runner, so nothing else is added.

## Consequences

- **Increment 3.2** fills in the presets. Each one needs a checked source and a Polish alias, or CI fails.
- **Increment 3.3** reads the bundled copy in the app and builds the search index from every name.
- **Name clashes** must be resolved deliberately; CI fails until they are. For example, a common alias like "rubber plant" can belong to only one preset.

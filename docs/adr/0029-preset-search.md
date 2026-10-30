# ADR-0029: Offline preset search

- Status: Accepted
- Date: 2026-10-30
- Related: M3 increments 3.2–3.3; AGENTS.md section 8; ADR-0028; FR-3; NFR Performance

## Context

FR-3 asks for preset search that is offline and typo-tolerant, matches common and Latin names and aliases, and answers in under 100 ms. Section 8 adds: normalise accents and case, match prefixes and aliases, and allow fuzzy matches with an edit distance of 1–2. Names come in English, Latin and Polish (ADR-0028).

## Decision

**Search runs in memory over every name of every preset,** with no package. The app loads the bundled file once (`presetCatalogProvider`) and builds a flat index of normalised names (`PresetSearch`). Every search scans it. At the v1 target size (120–150 presets, about 5 names each) that's well under a thousand short strings.

**Normalising:** lower case, accents removed, anything but letters and digits turned into a single space.
- Dart has no built-in Unicode normalisation, so a small table maps Polish letters (ą ć ę ł ń ó ś ź ż) and the common Western European accents. The validator's `normalize` (NFD plus `ł`) gives the same result for every name in the file.
- So "Wężownica", "WEZOWNICA" and "wężow" all match the same preset.

**Ranking:** each name scores; a preset takes its best name, and ties go alphabetically by common name.

| Score | Match | Example |
| --- | --- | --- |
| 100 | Exact name | "monstera" |
| 90 | The name starts with the query | "mon" |
| 80 | Every query word starts a word of the name, in any order | "plant snake", "cheese vine" |
| 70 − 10 per typo | Every query word is close to the start of a word of the name | "diffenbachia", "zamioculcus" |
| 40 | The name contains the query (3+ characters) | |

- **Typos allowed per word** follow its length, from section 8's edit distance 1–2: none up to 3 letters (where one typo makes another word), 1 for 4–6 letters, 2 for 7 or more.
- **The distance counts against the best beginning of the name word,** so half-typed misspellings match. It stops as soon as it can only exceed the allowance.
- **Each result says which name matched,** so the UI can show "Matched: Skrzydłokwiat" under "Peace lily".
- **An empty query returns nothing.** The add-plant screen (M4) shows the full list instead.

**Tolerant loading:** an entry the app can't read, such as an unknown method from a newer file format, is skipped instead of failing the list (AGENTS.md section 5). CI validates the file, so none are skipped today.

**The first 42 presets (3.2)** were researched in four parallel batches, then reviewed and merged.
- **Care text** is in original wording.
- **Facts** were checked against university extension services (NC State, Penn State, Florida, Wisconsin), the Missouri Botanical Garden, the RHS and the American Orchid Society.
- **Toxicity** comes from the ASPCA where it lists the plant. Otherwise it comes from NC State's toxicity data, or is marked `unknown`. Four presets are `unknown`: Chinese money plant, maidenhair fern, white bird of paradise and air plant.
- **All 116 source links** were rechecked after merging: each responds, and the page names the plant (the ASPCA pages under older botanical names).
- **Polish names** were checked against Polish Wikipedia or Polish garden publishers. Two rest only on retail listings: "Strelicja biała" for Strelitzia nicolai, and "Język teściowej" for the snake plant.

## Consequences

**Tests:**
- Ranking, accents, Polish names, word order and typos, on a small fixed list.
- On the real file: every preset is found by each of its names, and common real searches find the right plant first ("skrzydlokwiat", "grudnik", "diffenbachia").
- Timing: 150 presets stay under 100 ms per search (in practice a few milliseconds), checked in the unit tests and on the phone through the debug-only preset search screen.

**Scale:** if the list ever grows far beyond 150, the index can add a word-prefix map without changing results.

**M4** builds the add-plant screen on `presetSearchProvider`, and copies the chosen preset's values into the new plant as defaults (FR-3).

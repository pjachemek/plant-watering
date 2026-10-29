# presets/

Curated plant care presets bundled with the app (AGENTS.md section 8, ADR-0028).

| File | What it is |
| --- | --- |
| `presets.json` | The presets. Edit only this file. |
| `presets.schema.json` | JSON Schema for it. |
| `validate.mjs` | Checks the schema plus what a schema can't express: duplicate ids or names across presets, sorting by id, winter interval at least the summer one, a Polish alias on every preset. |
| `validate.test.mjs` | Tests for the validator. |

The app reads a compact copy, `app/assets/presets/presets.json`, written by the validator.

```sh
npm run presets:sync      # validate, then write the app's copy
npm run presets:validate  # validate and check the app's copy is current (CI)
npm run presets:test      # the validator's own tests
```

## Writing a preset

- **Care text in your own words.** Never copy text or data sets from other apps or websites.
- **Check the facts** against reputable horticultural references (university extension services, botanical gardens, the RHS), and list each one in `sources`. Before adding a link, open it and check its title: guessed page IDs often point at a different plant.
- **Toxicity to pets:** the ASPCA's toxic and non-toxic plant lists.
- **Intervals** are typical indoor starting points. The person can change them per plant, and the soil check always comes first.
- **Bump `version`** with every change. Plants keep the version they were created from.

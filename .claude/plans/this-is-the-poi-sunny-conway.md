# POI Content Drop — Session 1.4

## Context

Session 1.4 delivers first POI batch (Mohegan Bluffs, Southeast Light, North Light) into data layer. Content authored externally, source-cited in comments. Coordinate placeholders stay 0.0 until Session 2.2 map calibration. Scope locked to data file, lookup helpers, integrity tests — no UI, no screens, no theme touches.

## Changes

### 1. lib/data/pois.dart

Replace empty `allPois` list with:
- 3 top-level const POI instances (`mohegheanBluffs`, `southeastLight`, `northLight`)
- `poiBatch1` list grouping the three
- `kPois` export list (currently just `poiBatch1`, will expand in future batches)

Preserve exact content from user prompt — no rewrites, no typo "fixes" (Block Island spellings unusual but correct), no TODO resolution.

### 2. lib/data/content_index.dart

- Change all `allPois` references to `kPois`
- Add `poisByCategory` map: `Map<PoiCategory, List<Poi>>` built from kPois, preserving insertion order
- Leave existing quest/module helpers untouched (they reference empty lists now, will wire in Week 3)

### 3. test/content_integrity_test.dart

New file with 8 test groups checking POI data integrity:

1. **Unique IDs** — no duplicates in kPois
2. **ID format** — lowercase kebab-case only, no spaces/underscores
3. **Short description length** — ≤60 chars (map bottom-sheet constraint)
4. **No empty strings** — all required text fields populated
5. **Coordinate bounds** — mapX/mapY within [0.0, 1.0]
6. **Image asset path** — starts with `assets/images/`, ends with `.jpg`
7. **Category coverage** — every PoiCategory has at least one POI
8. **Empty relation lists** — questIds and moduleIds all empty (guard against half-wired refs until Week 3)

Failure messages must name offending POI id — "expected 58, got 71" without id is useless at scale.

## Verification

1. Run `flutter analyze` — zero issues
2. Run `flutter test` — all pass
3. Run `flutter build ios --simulator` — succeeds
4. Report POI counts per category, descriptions near 60-char limit, TODO markers in content

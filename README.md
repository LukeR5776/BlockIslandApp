# Block Island — Sustainable Tourism

An iPhone app about sustainable tourism on Block Island, Rhode Island. Built
for a visitor standing on the island, not a brochure to read before the trip.

## Mission

Block Island draws heavy seasonal tourism onto a small, ecologically fragile
island. This app gives visitors the context to tread lighter: what the
landscape is, what has shaped it, and what concrete actions help keep it
that way. Content is sourced from the Block Island Conservancy, The Nature
Conservancy's Block Island preserve pages, the Block Island Historical
Society, RI DEM, and the Town of New Shoreham — never invented. Every module
lists its sources in the app's About screen.

Voice is plain, specific, and useful to someone standing in the place.
Second person for quests and actions. No marketing language.

## Core features

Three tabs:

- **Education** — readable modules grouped by category: ecology, history,
  geology, community.
- **Exploration** — a pan/zoom map of the island, fully offline, with
  tappable points of interest. Each POI has a detail screen: image,
  category, a visitor note for practical cautions, description, related
  quests, and related learning modules.
- **Conservation** — concrete actions, events, and organizations to get
  involved with.

Progress is tracked locally: completed quests and read modules persist
across launches. There is no account, no backend, and no network
dependency — the map renders from a bundled offline tile archive, and all
other content ships in the app itself.

## Visual design

The app borrows the visual language of a NOAA nautical chart: a near-white
paper ground, pale blue and buff tints standing for water and land, hairline
rules, and a single magenta accent reserved for map markers, completion
states, and progress. Full spec in `DESIGN.md`.

## Status at MVP

This is a scoped, in-progress student project — five weeks, 25 build hours
total. Current state:

- Map, offline basemap, and POI detail screens are built.
- Education, Conservation, and quest/module completion are in progress
  (see `PLAN.md` for the week-by-week schedule).
- Content (POIs, modules, quests, conservation actions) is being written
  against a hard budget: 14 POIs, 10 modules, 20 quests, 8 actions.

## Stack

Flutter. Three dependencies beyond the Flutter team's own packages:
`provider`, `shared_preferences`, `url_launcher`, plus `flutter_map` +
`flutter_map_vector_tiles` + `latlong2` for the offline map. No backend, no
database, no code generation. See `CLAUDE.md` for the full operating rules
and `PLAN.md` for architecture and data model.

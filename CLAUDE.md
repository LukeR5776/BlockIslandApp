# CLAUDE.md — Block Island Sustainable Tourism App

Read this file at the start of every session. `DESIGN.md` describes the visual
direction. `PLAN.md` is the architecture, data model, and schedule.

---

## What this is

A Flutter iPhone app about sustainable tourism on Block Island, Rhode Island.
Three tabs:

- **Education** — readable modules grouped by category (ecology, history,
  geology, community).
- **Exploration** — a pan/zoom map of the island with tappable points of
  interest, each with a detail page.
- **Conservation** — concrete actions, events, and organizations to get
  involved with.

The goal is an app that feels modern, polished, and alive — rich interaction
and motion, not a static brochure. You have creative latitude on design and
UI code. Use it.

---

## Stack

- **State:** `provider` with an `AppState` `ChangeNotifier` above
  `MaterialApp`. Persist with `shared_preferences`. Local widget state
  (`setState`, animation controllers) is fine for UI-only state.
- **Navigation:** `Navigator` + `IndexedStack` today. Custom page routes and
  transitions are welcome.
- **Content:** `const` Dart in `lib/data/`. No backend.
- **Map:** `flutter_map` + `flutter_map_vector_tiles` rendering a bundled
  PMTiles archive. Fully offline — no network tile requests.
- **Fonts:** bundled `.ttf` files in `assets/fonts/`. Adding new bundled fonts
  is fine.

### Packages

You may add packages that serve the design — animation, effects, gestures,
icons (e.g. `flutter_animate`, `lottie`, `animations`, `rive`). Rules:

- Prefer pure-Dart packages. **Ask before adding anything with native
  iOS/Android code.** A previous project of mine was sunk by a deprecated
  native plugin.
- Pin exact versions in `pubspec.yaml`, no carets.
- Tell me what you added and why.

---

## Hard rules

Few, and they are firm.

1. **Content accuracy.** All prose in `lib/data/` describes a real place. Never
   invent a historical date, species name, statistic, organization, or
   measurement. No placeholder or lorem content. If content is missing, tell me
   which file needs it.
2. **No code generation.** No `build_runner`, `freezed`, `json_serializable`,
   or `.g.dart` files.
3. **Do not modify `ios/` or `android/`** unless I ask. Registering assets and
   fonts in `pubspec.yaml` is fine.
4. **No geolocation, camera, notifications, or analytics.**
5. **Don't fix a build error by adding a dependency.** Fix the code.

---

## Code style

- Keep the design-token files (`lib/theme/`) as the source of truth. Add or
  change tokens freely when the design needs them — just put them there rather
  than scattering magic numbers through screens.
- Extract reusable widgets into `lib/widgets/`. Keep files readable; split
  them when they get unwieldy.
- Comment *why*, not *what*.
- Data model classes stay immutable with `final` fields.

---

## Definition of done

Run these and paste the output:

```bash
flutter analyze                 # zero issues
flutter test                    # all pass
flutter build ios --simulator   # must succeed
```

Then launch on the simulator and report what you actually saw. Animations and
interactions are the point of this app — check that they run smoothly and
don't jank or overflow.

---

## Working protocol

- For large changes (new screens, redesigns, new packages), give a short plan
  first. Small and medium UI work: just build it.
- When I paste an error, read it literally.
- Say when something is a bad idea or will cost more than it's worth.

---

## Content voice

Sources are the Block Island Conservancy, The Nature Conservancy's Block Island
preserve pages, the Block Island Historical Society, RI DEM, and the town of
New Shoreham. Every module lists its sources in the About screen.

Voice: plain, specific, and useful to someone standing in the place. Second
person for quests and actions. No marketing language, no exclamation marks.

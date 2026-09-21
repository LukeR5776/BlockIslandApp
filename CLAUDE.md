# CLAUDE.md — Block Island Sustainable Tourism App

Read this file at the start of every session. `DESIGN.md` is the visual
specification. `PLAN.md` is the architecture, data model, and schedule.

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

Ship date is five weeks out. Total build budget is 25 hours. Scope discipline
matters more than completeness.

---

## Locked stack

Dependencies are final. There are three, and two are maintained by the Flutter
team:

```yaml
- Dependency list (final): provider, shared_preferences, url_launcher,
  flutter_map, flutter_map_vector_tiles, latlong2.
  Pin EXACT versions, no carets. Nothing else without asking.
```

- **State:** one `ChangeNotifier` called `AppState`, registered above
  `MaterialApp`. It holds completed quest IDs and read module IDs. Nothing else
  is persisted.
- **Navigation:** `Navigator` + `IndexedStack`. No router package.
- **Content:** all content is `const` Dart in `lib/data/`. There is no backend,
  no database, no network fetch, no JSON parsing, no auth.
- **Map:** - The map is flutter_map + flutter_map_vector_tiles rendering a bundled PMTiles archive. Fully offline. No network tile requests, ever.
- **Fonts:** bundled `.ttf` files in `assets/fonts/`. Not `google_fonts`.

---

## Hard prohibitions

These are not preferences. Violating one costs days we do not have.

1. **Do not add a package.** If a task seems to need one, stop and propose an
   approach without it. If there is genuinely no alternative, ask me and wait.
   This rule exists because a previous project of mine was sunk by a deprecated
   native plugin.
2. **Do not "fix" a build error by adding a dependency.** Fix the code.
3. **Do not use code generation.** No `build_runner`, `freezed`,
   `json_serializable`, or `.g.dart` files. A second source of truth produces
   stale-artifact errors that are slow to diagnose.
4. **Do not modify `ios/` or `android/`** unless I explicitly ask. Exception:
   registering an asset or font in `pubspec.yaml` is fine.
5. **Do not add geolocation, camera, notifications, or analytics.**
6. **Do not write placeholder or lorem content.** If content for a screen is
   missing, stop and tell me which file needs it. Invented facts about a real
   island are worse than a blank screen.
7. **Do not refactor code I did not ask you to touch.** Change the minimum
   number of files.
8. **Do not create files outside the tree in `PLAN.md`** without asking.

---

## Code style

- One public widget per file. No file over 250 lines. If a file is growing past
  that, extract a widget into `lib/widgets/` and tell me.
- **Never hardcode a `Color`, `TextStyle`, `EdgeInsets`, or `BorderRadius`.**
  Every one comes from `AppColors`, `AppText`, `AppSpace`, `AppRadius`. If a
  value you need is not in the token set, stop and ask — do not invent one.
- If a styled container appears twice, it becomes a widget in `lib/widgets/`.
  No one-off decorated `Container`s in screen files.
- No logic in `build()`. Extract to private methods, getters, or the model layer.
- `const` constructors everywhere they are possible. `StatelessWidget` unless
  local animation or controller state genuinely requires otherwise.
- Screens read persisted state with `context.watch<AppState>()` and mutate it
  only by calling methods on `AppState`. No `setState` for anything that
  survives a restart.
- Comment *why*, never *what*. No comments restating the line below them.
- Data model classes are immutable, `const`-constructible, with `final` fields.

---

## Definition of done

Before you tell me a task is complete, run all three and paste the output:

```bash
flutter analyze                 # must be zero issues, including infos
flutter test                    # all pass
flutter build ios --simulator   # must succeed
```

If any fail, fix them first. "Done except for some analyzer warnings" is not
done. A task is also not done if it introduced a hardcoded style value.

---

## Working protocol

- **Plan first.** For any task longer than a single file edit, state your plan
  in 3–6 bullets and wait for my go-ahead before writing code. Correcting a
  plan costs one message; correcting 300 lines of wrong code costs an hour.
- **One feature per session.** I will `/clear` between features. Do not carry
  assumptions across.
- **When I paste an error, read it literally.** Do not guess at causes. Ask for
  the file if you need to see it.
- **Flag uncertainty.** If you are unsure whether something matches `DESIGN.md`,
  say so rather than choosing. If a spec in `DESIGN.md` and a spec in `PLAN.md`
  conflict, stop and ask.
- **Say when something is a bad idea.** If I ask for something that will cost
  more than it is worth on this timeline, tell me before building it.

---

## Content rules

All prose in `lib/data/` describes a real place. Accuracy is a hard requirement.

- Never invent a historical date, species name, statistic, organization, or
  measurement. If content is needed, ask me to supply it.
- Sources are the Block Island Conservancy, The Nature Conservancy's Block
  Island preserve pages, the Block Island Historical Society, RI DEM, and the
  town of New Shoreham. Every module lists its sources in the About screen.
- Voice: plain, specific, and useful to someone standing in the place. Second
  person for quests and actions. No marketing language, no exclamation marks,
  no "discover the magic of."

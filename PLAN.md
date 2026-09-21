# PLAN.md — Architecture and schedule

Five weeks, five hours a week, 25 hours total. `CLAUDE.md` holds the operating
rules; `DESIGN.md` holds the visual spec.

---

## Do this before writing any code

**Enroll in the Apple Developer Program ($99/yr) today.** Approval takes 2–7
days. Nothing else on this plan blocks; this one does.

---

## File tree

Creating a file outside this tree requires asking first.

```
lib/
  main.dart                      // entry, Provider, MaterialApp, theme
  app_shell.dart                 // bottom nav + IndexedStack
  theme/
    colors.dart
    typography.dart
    spacing.dart
    app_theme.dart               // assembles ThemeData from the above
  models/
    poi.dart
    module.dart
    quest.dart
    conservation_action.dart
  data/
    pois.dart                    // const List<Poi>
    modules.dart                 // const List<Module>
    quests.dart                  // const List<Quest>
    actions.dart                 // const List<ConservationAction>
    content_index.dart           // ID lookup helpers
  state/
    app_state.dart               // ChangeNotifier
  screens/
    education/
      education_screen.dart
      category_screen.dart
      module_screen.dart
    exploration/
      map_screen.dart
      poi_screen.dart
    conservation/
      conservation_screen.dart
      action_screen.dart
    about_screen.dart
    dev/
      styleguide_screen.dart     // delete before submission
  widgets/
    island_map.dart              // FlutterMap + VectorTileLayer + MarkerLayer
    map_marker.dart              // the pin widget only, no map logic
    content_card.dart
    category_chip.dart
    section_header.dart
    quest_tile.dart
    progress_ring.dart
    primary_button.dart
    visitor_note.dart
    empty_state.dart
assets/
  map/blockisland.pmtiles        // Protomaps extract, offline tiles
  map/style.json                 // Protomaps light theme, restyled
  images/
  fonts/
test/
  app_state_test.dart
  content_integrity_test.dart
```

---

## Data model

This is the backbone. Every screen is a rendering of this data. Getting it
right in Week 1 makes the rest of the app mechanical.

```dart
enum PoiCategory { shore, trail, historic, wildlife, town }
enum ModuleCategory { ecology, history, geology, community }
enum QuestType { observe, count, reflect, act }
enum ActionKind { habit, event, volunteer, support }

class Poi {
  final String id;                // 'mohegan-bluffs'
  final String name;
  final String shortDescription;  // one line, shown in the map sheet
  final String description;       // 2–4 paragraphs
  final PoiCategory category;
  final double lat;               // WGS84, e.g. 41.1531
  final double lng;               // WGS84, e.g. -71.5520
  final String imageAsset;
  final String? visitorNote;      // practical caution, may be null
  final List<String> questIds;
  final List<String> moduleIds;
  const Poi({...});
}

class ModuleSection {
  final String heading;
  final String body;
  final String? imageAsset;
  const ModuleSection({...});
}

class Module {
  final String id;
  final ModuleCategory category;
  final String title;
  final String summary;
  final List<ModuleSection> sections;
  final int readMinutes;
  final List<String> relatedPoiIds;
  final List<String> sources;     // shown in About
  const Module({...});
}

class Quest {
  final String id;
  final String poiId;
  final String title;
  final String prompt;            // "Count how many stone walls you cross."
  final QuestType type;
  const Quest({...});
}

class ConservationAction {
  final String id;
  final String title;
  final String description;
  final ActionKind kind;
  final List<String> steps;
  final String? url;              // external organization link
  const ConservationAction({...});
}
```

Everything is `const`. IDs are the join keys — `content_index.dart` provides
`poiById`, `questsForPoi`, `modulesForPoi`, built once as top-level `final`
maps.

**Content budget: 14 POIs, 10 modules, 20 quests, 8 conservation actions.**
Enough to feel substantial, small enough that you can write all of it in one
sitting. Do not exceed it.

### AppState contract

The entire mutable state of the app:

```dart
class AppState extends ChangeNotifier {
  Set<String> get completedQuestIds;
  Set<String> get readModuleIds;
  Set<String> get committedActionIds;

  bool isQuestComplete(String id);
  bool isModuleRead(String id);
  bool isActionCommitted(String id);

  void toggleQuest(String id);     // notifies, then persists
  void markModuleRead(String id);
  void toggleAction(String id);

  int get questsCompleted;
  int poisVisited(List<Poi> all);  // a POI counts as visited when any of
                                   // its quests is complete

  Future<void> load();             // called once in main() before runApp
}
```

Persistence is three `StringList` entries in `shared_preferences`. Writes are
fire-and-forget after `notifyListeners()` so the UI never waits on disk.

---

## The map

**Working and verified.** `flutter_map` + `flutter_map_vector_tiles` rendering
a bundled Protomaps PMTiles extract. Pure Dart, no native plugin, fully
offline (cell coverage on the island is poor). Road and place labels fade in
with zoom automatically from the style — do not rebuild that behavior.

**Camera:** center `LatLng(41.172, -71.578)`, `minZoom` 11, `maxZoom` 16,
rotation disabled, `CameraConstraint.contain` slightly inside the extract
bbox (`-71.65, 41.11, -71.51, 41.27`). Tune the numbers by hot reload.

**POI pins:** a `MarkerLayer` above the `VectorTileLayer`, one `Marker` per
POI at `LatLng(poi.lat, poi.lng)`. Each marker is a 44×44 box (the hit area)
containing the 14pt `MapMarker` visual from DESIGN.md. flutter_map draws
markers in screen space, so they stay the same size at every zoom with no
extra code. The marker is a circle, so keep the default centered alignment;
only a teardrop pin would need `Alignment.topCenter`.

Do **not** add POIs as GeoJSON sources or style layers. Tap handling on style
layers is harder and pins would no longer use the design system.

**Coordinates:** look up each POI's lat/lng once (Google Maps → right-click →
copy coordinates) and store them in `pois.dart`. No projection math anywhere.

**Style edits:** only in Maputnik, re-exported to `assets/map/style.json`.
Protomaps and OpenMapTiles use different schemas — only Protomaps styles work
with this archive. If the basemap's own POI icons clash with our pins, remove
the `pois` layers from the style rather than fighting it in code.

**Pinned packages:** `flutter_map_vector_tiles` is new and its API differs
from the older `vector_map_tiles`. The agent must work from current pub.dev
docs, never from memory. Exact versions, no carets, no upgrades before v1.0.

**Attribution:** the About screen must credit "© OpenStreetMap contributors"
and Protomaps.

---

## Week 1 — Foundation and content (5h)

Goal: a running, navigable app with real data and no features.

| # | Time | Output |
|---|---|---|
| 1.1 | 30m | `flutter create`, pin the Flutter version, `git init`, drop in these three `.md` files, add the dependencies listed in `CLAUDE.md` |
| 1.2 | 60m | Theme layer + styleguide screen |
| 1.3 | 60m | Models, empty data files, `AppState` with tests |
| 1.4 | 90m | **You, not the agent:** write all content |
| 1.5 | 60m | `AppShell` with bottom nav and three placeholder screens |

Session 1.2 earns its hour. A styleguide screen means every later session has a
visual reference, and design drift gets caught in Week 1 rather than Week 4.

For 1.4, write the content in a **separate Claude conversation**, not in Claude
Code — you want a research-and-writing session, not a coding session. Verify
every factual claim. Paste the finished Dart into `lib/data/`.

**Prompt for 1.2:**

> Read CLAUDE.md and DESIGN.md. Build the theme layer: colors.dart,
> typography.dart, spacing.dart, and app_theme.dart, using exactly the tokens
> in DESIGN.md — do not invent or adjust any value. Then create
> lib/screens/dev/styleguide_screen.dart displaying every color swatch with its
> token name, every text style with its name rendered in a sample sentence, the
> spacing scale, and both button variants. Wire it as the temporary home. Plan
> first, then wait for my approval.

**Prompt for 1.3:**

> Read CLAUDE.md and the data model section of PLAN.md. Build the four model
> files exactly as specified, create the four data files in lib/data/ with
> empty const lists, build content_index.dart with the lookup helpers, and
> build lib/state/app_state.dart to the contract in PLAN.md. Then write
> test/app_state_test.dart covering: toggling a quest, the persistence
> round-trip via SharedPreferences.setMockInitialValues, and the progress
> counts. Plan first.

---

## Week 2 — The map, and TestFlight (5h)

| # | Time | Output |
|---|---|---|
| 2.0 | 90m | ✅ Done — PMTiles spike, island renders offline |
| 2.1 | 60m | `MarkerLayer` POI pins, tap → bottom sheet preview |
| 2.2 | 60m | Category filter chips; you restyle `style.json` in Maputnik |
| 2.3 | 60m | `PoiScreen` — image, description, visitor note, quests, related modules |
| 2.4 | 90m | **Apple pipeline: App ID, certificates, App Store Connect record, first TestFlight upload** |

Session 2.4 is the week's real deliverable. Get a build onto your phone via
TestFlight even though the app is half finished. Signing and provisioning is
where student projects die; isolate that pain now, with three weeks of buffer
behind it, rather than the night before submission.

**Prompt for 2.1:**

> Read the map section of PLAN.md. Move the working FlutterMap out of
> map_screen.dart into lib/widgets/island_map.dart without changing its
> behavior. Build lib/widgets/map_marker.dart to the MapMarker spec in
> DESIGN.md. Add a flutter_map MarkerLayer above the VectorTileLayer with one
> 44×44 Marker per POI in kPois at LatLng(poi.lat, poi.lng). Tapping a marker
> calls onPoiTap(Poi), which map_screen.dart uses to show a bottom sheet with
> name, category chip, shortDescription, and a button that pushes PoiScreen.
> Tapping empty map clears the selection. Use flutter_map's current API from
> pub.dev, not memory. Do not add packages or touch style.json. Plan first.

---

## Week 3 — Education and Conservation (5h)

| # | Time | Output |
|---|---|---|
| 3.1 | 75m | Education: category grid → module list → module reader |
| 3.2 | 45m | Module read-tracking, persisted, checkmarks on lists |
| 3.3 | 75m | Conservation: actions grouped by kind, detail screen, `url_launcher` |
| 3.4 | 60m | Quest completion with haptics and animation, reflected on POI screens |
| 3.5 | 45m | `ProgressRing` on each tab header, "7 of 14 places explored" |

---

## Week 4 — Polish and submit (5h)

| # | Time | Output |
|---|---|---|
| 4.1 | 60m | Empty states, page transitions, haptics pass, delete the styleguide screen |
| 4.2 | 60m | App icon, launch screen, About screen with sources and attributions |
| 4.3 | 45m | Semantics labels; test at the largest Dynamic Type setting |
| 4.4 | 60m | Device matrix: iPhone SE and a Pro Max, at minimum |
| 4.5 | 75m | **Screenshots, listing copy, privacy label, submit** |

The privacy nutrition label is trivial here and that is by design: no data
collected, no tracking, no third-party SDKs. That also means no App Tracking
Transparency prompt and a materially smoother review.

**Submit by Thursday of Week 4.** Typical review is 24–48 hours.

---

## Week 5 — Buffer (5h)

Reserved entirely for review rejections, TestFlight bug reports, and
resubmission. If review passes clean on the first attempt, spend the time on
content depth and a second device pass.

**Do not plan features into Week 5.** The moment you do, the safety margin is
gone.

---

## Testing

**Every session.** The agent runs `flutter analyze && flutter test &&
flutter build ios --simulator` and pastes the output before claiming a task is
done. This is in `CLAUDE.md` because it catches most regressions instantly.

**`test/app_state_test.dart`** — toggle behavior, persistence round-trip,
progress math.

**`test/content_integrity_test.dart`** — the sleeper test, and the highest
value-per-line in the project. Broken ID references are the most likely bug
class in a data-driven app, and this eliminates the category:

- Every `Poi.questIds` entry resolves to a real `Quest`.
- Every `Quest.poiId` resolves to a real `Poi`.
- Every `Poi.moduleIds` and `Module.relatedPoiIds` entry resolves.
- No duplicate IDs in any collection.
- Every `lat` is within 41.11–41.27 and every `lng` within -71.65 to -71.51
  (the extract bbox). Catches swapped or sign-flipped coordinates.
- Every `imageAsset` path is declared in `pubspec.yaml`.
- Every `ConservationAction.url` parses as an absolute URL.

**CI.** A GitHub Action on push running `flutter analyze` and `flutter test`.
Ten minutes to set up.

**Manual smoke test** — run on a physical device before every TestFlight
upload:

1. Cold launch: no white flash, no unstyled frame.
2. All three tabs load; switching tabs preserves map zoom and pan.
3. Every marker opens the correct POI.
4. Pinch to max zoom: pins stay anchored on their locations, no jank, no
   blank tiles at the camera edges.
5. Complete a quest, force-quit, relaunch: still complete.
6. Read a module to the end: marks read, persists.
7. Airplane mode, cold launch: map and labels render; external links fail
   with the SnackBar.
8. Largest Dynamic Type: no clipped text, no overflow stripes.
9. Rotate: either locked to portrait, or laid out correctly.

**Real-time loop.** Keep `flutter run` on a physical device with hot reload
during every session. The agent writes, you hot-reload and look. Never batch
visual review to the end of a session.

---

## Working with the agent

- Plan mode first, always. Approve the plan, then let it execute.
- One feature per session, then `/clear`.
- Name files explicitly: "read `lib/theme/typography.dart` and
  `lib/widgets/content_card.dart`, then build `module_screen.dart` using
  those" beats letting it search.
- Commit after every green session. Rollback granularity is the safety net.
- Paste errors verbatim — full stack trace or full `flutter analyze` output.
  Never paraphrase an error.
- For anything touching `flutter_map` or `flutter_map_vector_tiles`, the agent
  works from current pub.dev docs. If it can't fetch them, paste them in.
  Code written from memory for these packages will look right and not compile.
- **Never let it resolve a build failure by adding a package.** This is the
  exact failure mode that sinks projects. The answer is always no; ask for an
  approach without the dependency.

---

## Cut lines, in priority order

Decide these now, so you are not negotiating with yourself at 11pm in Week 4.

1. **GPS "you are here."** Cut by default. It adds a plugin, a permission flow,
   an `Info.plist` string, a privacy label entry, and debugging that is
   impossible indoors. A ten-square-mile island works fine without it.
2. **Photo quests.** Cut. Camera plugin, permissions, storage. Replaced by
   `reflect` and `count` quests — a prompt and a completion tap.
3. **Module read-progress on scroll.** Degrade to a manual "Mark as read"
   button.
4. **iPad support.** Declare iPhone-only. Halves the layout testing.
5. **Dark mode.** Locked to light in `DESIGN.md`. A well-executed light theme
   beats a rushed dual theme, and reviewers do not care.

---

## Risks

| Risk | Mitigation |
|---|---|
| Developer account delayed | Enroll today, before any code |
| Signing and provisioning failure | TestFlight in Week 2, not Week 4 |
| Map package API churn or hallucinated API | Exact version pins, no upgrades before v1.0, agent works from pasted docs |
| Style edits break the map | Keep the stock Protomaps `style.json` committed; restyle in small Maputnik passes, one commit each |
| Content writing balloons | Hard cap of 14 POIs / 10 modules, written in Week 1 in a separate thread |
| Rejection under Guideline 4.2, minimum functionality | The quest system, progress tracking, and original written modules clear this. Lead the App Store description with the educational modules and interactive map, not "a guide to Block Island" |
| A good idea arrives in Week 3 | Write it in `IDEAS.md`. Ship v1.0. That is v1.1 |
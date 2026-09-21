# DESIGN.md — Visual specification

Implement this literally. Every value here is a decision, not a starting point.
If you need a value that is not in this file, stop and ask.

---

## Direction

The app borrows the visual language of a **NOAA nautical chart**. This is not
decoration — it is the vernacular of the subject. Block Island is an island you
reach by boat, and charts are how it has been described for two hundred years.

What that gives us concretely:

- A near-white paper ground, not a warm cream. Charts are printed on white.
- Pale blue and buff as *tinted surfaces*, standing for water and land, used to
  encode category rather than to decorate.
- Hairline rules and small type. Charts are dense and quiet.
- **Chart magenta as the single accent.** On a nautical chart, magenta marks
  lighted aids to navigation, cautionary notes, and anything the mariner must
  attend to. Our points of interest are aids to navigation. Magenta is used for
  map markers, completion states, and progress — and almost nowhere else.

Boldness is spent in exactly one place: the magenta markers on the map. Every
other surface stays disciplined and quiet so those markers carry the app.

**Explicitly avoided,** because they are the current defaults of generated
design rather than choices: warm cream backgrounds with a terracotta accent;
tracked-out uppercase eyebrow labels above headings; identical rounded cards
with one grey shadow under everything; gradient washes; glow effects; metadata
strings joined with middle dots; arrows appended to button text.

---

## Color

`lib/theme/colors.dart` — raw palette only, no semantic aliases in this file.

```dart
class AppColors {
  // Ground
  static const paper     = Color(0xFFFDFDFB); // app background
  static const surface   = Color(0xFFFFFFFF); // cards, sheets
  static const hairline  = Color(0xFFCBD6DC); // borders, rules

  // Chart tints — surfaces only, never text
  static const shoal     = Color(0xFFE3EDF2); // pale chart blue (water)
  static const land      = Color(0xFFF0E8D8); // chart buff (land)

  // Ink
  static const ink       = Color(0xFF16212B); // primary text
  static const inkMuted  = Color(0xFF5E7280); // secondary text, captions

  // Primary interactive
  static const depth     = Color(0xFF1D4A66); // buttons, links, active nav

  // The accent. Markers, completion, progress. Use sparingly.
  static const beacon    = Color(0xFFB12C7D);

  // Supporting
  static const kelp      = Color(0xFF4A6B4F); // conservation
  static const hazard    = Color(0xFFA8431F); // visitor cautions

  // POI categories — used at 0.12 opacity for chip fills,
  // full opacity for chip text and marker rings.
  static const catShore    = Color(0xFF2E7191);
  static const catTrail    = Color(0xFF4A6B4F);
  static const catHistoric = Color(0xFF7A5C3E);
  static const catWildlife = Color(0xFF6B7F3F);
  static const catTown     = Color(0xFF8C4B3A);
}
```

Rules:

- `paper` is the scaffold background on every screen. `surface` is for cards
  and sheets only. The contrast between them is deliberately slight.
- `shoal` and `land` are surface tints. Never put text in these colors.
- Text is `ink` or `inkMuted`. There is no third text color, and no opacity
  applied to text — use `inkMuted` instead.
- `beacon` appears on: map markers, completed-quest checkmarks, the progress
  ring fill, and the active tab indicator. Nowhere else.
- Lock the app to light mode. Declare it in `MaterialApp` with
  `themeMode: ThemeMode.light` and a light-only `theme`.

---

## Type

One family: **IBM Plex Sans** (OFL). It has enough character in the `a`, `g`,
and the squared bowls to not read as a system default, and it holds up at small
sizes — which a chart-derived design needs.

**IBM Plex Mono** is used in exactly two places: the debug coordinate readout,
and quest/module counters where tabular figures stop numbers from jittering as
they increment. Nowhere else. It is not a decorative label face here.

Bundle weights 400, 500, 600 of Plex Sans and 500 of Plex Mono into
`assets/fonts/`. Register in `pubspec.yaml`.

`lib/theme/typography.dart`:

| Token | Size | Weight | Height | Tracking | Use |
|---|---|---|---|---|---|
| `display` | 30 | 600 | 1.20 | −0.4 | Tab screen titles |
| `title` | 22 | 600 | 1.25 | −0.2 | POI names, module titles |
| `heading` | 17 | 600 | 1.35 | 0 | Section headers, card titles |
| `body` | 16 | 400 | 1.60 | 0 | All prose |
| `bodyStrong` | 16 | 500 | 1.55 | 0 | Emphasis within prose |
| `caption` | 13.5 | 400 | 1.40 | 0 | Metadata, helper text |
| `label` | 12 | 500 | 1.20 | 0 | Category chips, tab labels |
| `data` | 13 | 500 | 1.20 | 0 | Mono. Counters, coordinates |

Typographic rules:

- **Sentence case everywhere.** No uppercase labels, no `letterSpacing` above
  zero on small text. Uppercase tracked labels are the single most common tell
  of templated design.
- Body prose is capped at roughly 68 characters per line. On iPhone at 16pt
  with 16pt side padding this happens naturally; do not widen it.
- Hierarchy comes from size, weight, and `inkMuted` — never from color accents
  on individual words, and never from italicizing one phrase in a heading.
- No heading is followed by a smaller label restating it.

---

## Space, radius, elevation

```dart
class AppSpace {
  static const xs  = 4.0;
  static const sm  = 8.0;
  static const md  = 16.0;
  static const lg  = 24.0;
  static const xl  = 32.0;
  static const xxl = 48.0;
}

class AppRadius {
  static const sm   = 6.0;   // chips
  static const md   = 10.0;  // cards
  static const lg   = 18.0;  // bottom sheets
  static const full = 999.0; // markers, progress ring
}
```

- Screen horizontal padding is always `AppSpace.md` (16). No exceptions.
- Vertical rhythm: `lg` (24) between major sections, `md` (16) between cards,
  `sm` (8) between a label and its value.
- There are six spacing values. Not five, not seven, and never an arbitrary
  number in between.

**Elevation.** Cards use a hairline border, not a shadow:

```dart
Border.all(color: AppColors.hairline, width: 1)
```

This is the chart convention and it keeps the surface flat and quiet. Exactly
one shadow exists in the app, on the bottom sheet only:

```dart
BoxShadow(
  color: Color(0x1416212B), // AppColors.ink at 8% opacity
  blurRadius: 24,
  offset: Offset(0, -4),
)
```

Do not add shadows to cards, buttons, chips, or the nav bar.

---

## Components

Build these once in `lib/widgets/`. Everything downstream composes them.

**`ContentCard`** — `surface` fill, `hairline` 1px border, `AppRadius.md`,
`AppSpace.md` internal padding. Optional leading category chip, `heading`
title, `caption` subtitle, optional trailing checkmark in `beacon`. Tapping it
gives `HapticFeedback.selectionClick()`.

**`CategoryChip`** — category color at 12% opacity fill, category color text in
`label`, `AppRadius.sm`, padding `sm` horizontal / `xs` vertical. No border, no
icon.

**`SectionHeader`** — `heading` text, optional `caption` trailing count in
`data`. A `hairline` rule sits below it at `sm` distance. No uppercase eyebrow
above it.

**`MapMarker`** — the one bold element. A filled `beacon` circle, 14pt
diameter, with a 3pt white ring and a 1pt `beacon` outer ring — the chart
symbol for a lighted aid. Completed POIs get a solid white dot at center.
Selected marker scales to 1.25 with a 140ms `Curves.easeOut`. Marker size must
stay constant on screen at all zoom levels.

**`QuestTile`** — leading 22pt circle: `hairline` outline when incomplete,
filled `beacon` with a white check when complete. `bodyStrong` title,
`caption` prompt. Tapping toggles completion with
`HapticFeedback.lightImpact()` and a 180ms scale-and-fill transition on the
circle only. This is the app's one piece of celebratory motion — nothing else
animates on completion.

**`ProgressRing`** — 36pt, 3pt stroke, `hairline` track, `beacon` fill,
centered `data` text showing completed count. Animates over 300ms when the
count changes.

**`PrimaryButton`** — `depth` fill, white `bodyStrong` text, `AppRadius.md`,
48pt tall, full width. **`SecondaryButton`** — transparent fill, `hairline`
border, `depth` text, same metrics.

**`VisitorNote`** — `land` fill, 3pt `hazard` left border, `AppRadius.sm`,
`caption` text in `ink`. For practical cautions like "141 steps down, no
handrail at the bottom."

---

## Motion

Motion answers a user action or it does not exist. There are exactly four
animations in the app:

1. Marker select — 140ms scale.
2. Quest complete — 180ms circle fill.
3. Progress ring — 300ms arc sweep.
4. Page push — `CupertinoPageTransitionsBuilder`.

No entrance animations on scroll. No staggered card reveals. No shimmer
loading states — there is nothing to load.

---

## Native-feel checklist

These five items are most of the gap between "looks like a web page" and
"looks like an app." Verify each before the first TestFlight build.

- [ ] `CupertinoPageTransitionsBuilder` set in `ThemeData.pageTransitionsTheme`.
- [ ] `SafeArea` on every screen; bottom nav respects the home indicator.
- [ ] Every tappable target is at least 44×44pt, including map markers
      (use a transparent hit-test padding around the 14pt visual).
- [ ] Haptics: `selectionClick` on card and marker taps, `lightImpact` on quest
      completion. Nothing else.
- [ ] A real launch screen matching `paper`, so there is no white flash or
      unstyled frame on cold start.

---

## Empty states and errors

An empty screen states what goes there and how to fill it, in one sentence, in
`body` on `paper`, centered with `xl` padding. No illustration, no apology.

Example — Conservation tab with no completed actions:
"Actions you commit to will collect here."

The only failure path in the app is `url_launcher` failing to open an external
link. Handle it with a `SnackBar`: "Couldn't open that link. Try again with a
connection." Errors state what happened and what to do. They do not apologize.

---

## Accessibility floor

- Every map marker has a `Semantics` label with the POI name and category.
- Every icon-only control has a `Semantics` label.
- Layout survives the largest Dynamic Type setting with no clipping and no
  overflow errors. Test this before submission — it is a common rejection.
- All text/background pairs meet 4.5:1. The specified palette does; if you
  introduce a new pairing, verify it.

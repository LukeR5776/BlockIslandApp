# Onboarding — "Landfall"

First-launch sequence, ~14 s, five beats. It auto-plays, and you can tap to
advance, drag to scrub, or skip. Code is in `lib/features/onboarding/`. Every
timing, color and curve is in `lib/theme/onboarding_tokens.dart`.

## Concept

The sequence shows you arriving at the island from the sea at night. Spray
drifts over dark water, a lighthouse beam sweeps from Southeast Light's real
position, and the real coastline draws itself. Next, beacon chart-lights come
on at every real place, then dawn breaks and the scene drains into the
paper-white app.

The island outline is the shared element across all beats. A "camera" zooms
and pans on it instead of cutting between screens. The outline was extracted
once from the bundled PMTiles archive (`island_outline.dart`), so it is the
same shoreline the map shows.

Everything shown comes from `lib/data/` at runtime: the place count, POI
positions, the Mohegan Bluffs card, the module title and read time, and the
organization names. The copy describes what the app does and makes no claims
about the island.

## Storyboard

| # | ms | Beat | What moves | Copy |
|---|---|---|---|---|
| 1 | 0–3400 | Hero | Particles converge onto the coast in path order, the stroke draws in behind them, the fill fades up, the beam sweeps, title letters rise through a mask, and coordinates type on (Plex Mono) | **Block Island** |
| 2 | 3400–6200 | Read | Camera pushes in (×2.15) so the coast becomes a backdrop; particles scatter; the four Education category cards spring out of the island into the real 2×2 grid; a real module card rises with its text lines drawing in | Learn the island first |
| 3 | 6200–9200 | Explore | Match cut: the cards collapse into the first four markers; the camera pulls back to the map; 31 markers drop north to south with a spring; sonar pulses; a dashed course draws; the counter ticks to the place count; a chart callout for Mohegan Bluffs rises on a leader line | Find it on the map |
| 4 | 9200–11600 | Care | The island tints kelp, a compass rose draws in clockwise from north, kelp rings bloom from each marker, and organization pills float up and bob | Look after what you visit |
| 5 | 11600–14000 | Landfall | Aurora warms to dawn, then paper. The island takes on the app's chart colors. The real `AppNavBar` rises into its exact position, then the **Come ashore** button arrives (breathing glow, light sweep) | **Block Island** |

Pacing: the hero builds slowly, explore is the peak (marker cascade and
counter), and care and landfall release the energy with longer eases and
less motion.

**Exit:** the overlay sits above the already-built `AppShell`. Skip or
Come ashore opens a circular hole from the pressed control, with a beacon rim,
onto the real app. The replica nav bar is pixel-aligned with the real one, so
the handoff has no seam.

## Palette and type

The palette is the app's chart palette pushed darker: `night`/`sea` (from
`depth`), `glow` (= `catShore`), `seaGlass`, `beacon` for markers and the
active progress tick, `kelp` for care, and `dawn` tones for the landfall. Text
is `foam` on night, which lerps to `ink` on paper. A scrim under the copy
keeps it readable over any aurora frame.

Type is IBM Plex Sans SemiBold for headlines and Plex Mono for coordinates,
counters and "MIN READ", following `AppText.data`.

## Interaction

- **Tap:** fast-forwards (critically damped spring) to the next beat's
  composed frame. A tap before the hero settles completes the hero first.
- **Drag:** scrubs the timeline, with one screen width = 2.8 s. On release,
  it snaps to the nearest beat, or to the neighbouring beat on a fling. The
  finger also drives a parallax offset that springs back.
- **Haptics:** light at each beat, medium when the title lands and on exit,
  selection click on taps and Skip.
- **Reduce motion** (`MediaQuery.disableAnimations`): no particles, beam,
  ambient drift or shimmer. Each beat shows only its composed frame, holds
  for 4.2 s, then crossfades in 320 ms. Taps and swipes step between beats.
- **Accessibility:** each beat's copy is a single live-region label.
  Decoration is excluded from semantics, and the app underneath is excluded
  while the overlay is up. Skip reads "Skip introduction". Both buttons are
  ≥ 44 pt Material buttons. Text scale is clamped to 1.3× inside the
  sequence, and headlines shrink to fit their longest word.

## Tweaking

All of these are in `lib/theme/onboarding_tokens.dart`:

- **Beat lengths:** `OnboardingTiming.beatStart` and `total`. Keep each
  `settle` value after its beat's last entrance and before
  `beatEnd - copyOut`.
- **Any single effect:** each has a `(start, end)` pair, e.g. `coastDraw`,
  `markerDropSpread`, `sheetRise`.
- **Camera shots:** `_poses` in `stage.dart` holds scale and pan per beat.
- **Colors:** `OnboardingColors`.
- **Motion feel:** `OnboardingCurves`. `SpringCurve(damping:)`: lower
  values bounce more.
- **Particles:** `OnboardingParticles` sets the count per reference screen,
  the cap, and the raster budget that halves the count on slow devices.
- **Copy:** `BeatCopy.of` in `beats/beat_copy.dart`.

## Debug switches (debug builds only)

Run these with `flutter run`. Launching through `simctl` did not pick up the
defines.

- `--dart-define=ONBOARDING=always`: show the sequence on every launch.
- `--dart-define=ONBOARDING_AT=6500`: freeze at 6.5 s, for screenshots.
- `--dart-define=ONBOARDING_REDUCED=true`: force reduce motion.

For the future About screen, `AppState.resetOnboarding()` replays the
sequence on next build.

## Decisions

- **No new packages.** The sequence is built from Flutter primitives:
  one `AnimationController` whose value is the time in ms,
  `CustomPainter`s, and `SpringSimulation`.
- **No fragment shader.** Radial-gradient pools look close enough and need
  no fallback path.
- **Light only, portrait only, iPhone only.** The app is locked to all
  three, so there are no separate dark, landscape or tablet layouts. Layout
  is computed from screen size and safe areas, so it adapts across iPhone
  sizes.
- **No tilt parallax.** It would need a native sensor plugin.
- **Performance:** each frame draws particles in 3 `drawRawPoints` calls
  into reused buffers. The coast path and metric are built once per layout.
  Letter fades are baked into the text color rather than `Opacity` layers.
  Aurora pools are drawn as circles the size of their own radius rather than
  as full-screen fills.

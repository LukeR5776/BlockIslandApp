# DESIGN.md — Visual direction

This is a direction, not a spec. Make design decisions freely. The aim is an
app that feels **modern, attractive, and alive**: fluid motion, responsive
touch, depth, and moments of delight. When in doubt, choose the more
interactive, more polished option.

---

## Direction

The subject is an island reached by boat — ocean, bluffs, light, wind,
weathered shingle, lighthouses, and nautical charts. Draw on that for color,
texture, and motion. Everything else is open.

Directions worth exploring:

- **Rich, layered surfaces.** Translucency and blur (frosted glass over the
  map), soft shadows, gradients that evoke water and sky, parallax headers
  with island imagery.
- **Bold color.** Deep ocean blues, sea-glass greens, sunset warmth, and a
  strong accent (chart magenta is a good candidate). Dark mode is welcome.
- **Expressive type.** A display face with character for headings paired with
  a clean text face. Large, confident titles.
- **Immersive map.** The map is the centerpiece. Animated markers, smooth
  camera flights to POIs, draggable bottom sheets, previews that expand into
  detail pages.

---

## Motion

Motion is a core feature, not garnish. Use it everywhere it makes the app feel
responsive and tactile:

- Staggered entrance animations for lists and cards.
- Hero / shared-element transitions from cards and markers into detail pages.
- Spring physics on drags, sheets, and press states (scale down on press).
- Scroll-driven effects: parallax, collapsing headers, fading app bars.
- Celebratory feedback on completing quests and actions — confetti, ripples,
  animated progress rings, counters that tick up.
- Animated tab switches and icon morphs in the nav bar.
- Pulsing or breathing map markers; animated route or trail lines.

Keep it smooth: 60fps on device, durations mostly 200–600ms, natural curves
(`Curves.easeOutCubic`, springs). Respect `MediaQuery.disableAnimations` by
shortening or skipping non-essential motion.

---

## Interaction

- Haptics on meaningful touches — taps, toggles, completions, sheet snaps.
- Gestures: swipe between items, pull to expand, long-press previews.
- Every tappable target at least 44×44pt.
- Empty states can be illustrated or animated; keep the copy short and useful.

---

## Tokens

`lib/theme/` (`colors.dart`, `typography.dart`, `spacing.dart`,
`app_theme.dart`) holds the design tokens. Evolve them freely — add colors,
gradients, shadows, durations, curves, and text styles as the design grows.
Define them there and reference them from widgets.

---

## Floor

Non-negotiable regardless of style:

- `SafeArea` respected; bottom nav clears the home indicator.
- Layout survives the largest Dynamic Type setting without overflow.
- Text meets 4.5:1 contrast against its background.
- Map markers and icon-only controls have `Semantics` labels.
- Map stays fully offline.

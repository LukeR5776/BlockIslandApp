# IDEAS.md

Ideas that arrived mid-build. Not scheduled. See `PLAN.md` for what ships.

---

## CategoryChip takes a label and a color

`CategoryChip` takes a `PoiCategory` today, but modules use
`ModuleCategory`, so it can't label module cards.

Preferred shape: the constructor takes a label `String` and a `Color`, with
static helpers `CategoryChip.forPoi(PoiCategory)` and
`CategoryChip.forModule(ModuleCategory)`.

Solve before 3.1 needs a chip on module cards. Note that `ModuleCategory`
has no category colors in `DESIGN.md` yet, so it needs a design decision
first.

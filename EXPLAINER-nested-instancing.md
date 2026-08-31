# How it works

Cycles stores a scene as a flat list of world-space objects, so N trees of M
leaves cost N × M records. This stores **one group of M members plus N
placements** and composes each member's world transform during traversal
instead of storing it. On the GPU that becomes a three-level OptiX graph.

## The two toggles

**Render Instances Directly** — required. Cycles reads an object's
geometry-nodes instances straight from the evaluated geometry, instead of having
the depsgraph expand them into real duplicates first. That expansion is what
makes a big scatter slow to sync after every edit, and nesting is built on top
of it. It's stored as a plain custom property, so the file still opens in
standard Blender, where it does nothing.

**Solid/EEVEE Viewports** — optional. The normal viewport builds real geometry
for every instance: millions of duplicates for a forest, which stalls or runs
out of memory long before Cycles would. Unticking this culls the whole set in
one decision, so those duplicates are never generated — while the object still
appears in the Rendered viewport and in final renders. Select it from the
Outliner while it's hidden.

## Is it correct

Rendering with the feature off and on inside one Blender session gives
byte-identical output where it should. Normal, True Normal and Position probes:
zero differing channels. The scene seen from the light: zero.

## What it can't do yet

- OptiX only — no CPU path, no macOS.
- One emissive or volume prototype disables nesting for the whole scene.
- Each group member still costs a full object record — the main memory cost left.
- Motion blur with groups is untested.

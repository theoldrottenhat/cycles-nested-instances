# How it works

Cycles stores a scene as a flat list of world-space objects, so N trees of M
leaves cost N × M records at 336 bytes each. This stores **one group of M
members plus N placements**, and composes a member's world transform during
traversal instead of storing it. On the GPU that becomes a three-level OptiX
graph: scene → placement → group → member → geometry.

Two smaller changes ride along:

- Cycles reads geometry-nodes instances straight from the evaluated geometry,
  instead of having the depsgraph expand them into a dupli list first.
- A per-object **Solid/EEVEE Viewports** toggle, so a very heavy object can
  render in Cycles without ever loading into the rasterised viewport.

## Is it correct

Rendering with the feature off and on inside one Blender session gives
byte-identical output where it should. Normal, True Normal and Position probes:
zero differing channels. The scene seen from the light: zero. Remaining shading
differences sit on leaf silhouettes and are symmetric.

## What it can't do yet

- OptiX only — no CPU path (bundled Embree allows one instancing level).
- Switched on by an environment variable, not a UI option.
- One emissive or volume prototype disables nesting for the whole scene.
- Each group member still costs a full object record — the main memory cost
  that's left.
- Motion blur with groups is untested.

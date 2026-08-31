# How it works

## Render instances directly

Normally the depsgraph expands a geometry-nodes scatter into a real duplicate
per instance, and Cycles then syncs them one at a time. Both halves cost time
proportional to the instance count, on every edit. This reads the instances
straight from the evaluated geometry and skips the expansion. Stored as a plain
custom property, so the file still opens in standard Blender, where it does
nothing.

## Nested instancing

Cycles stores a scene as a flat list of world-space objects, so N trees of M
leaves cost N × M records. This stores **one group of M members plus N
placements** and composes each member's world transform during traversal
instead of storing it. On the GPU that becomes a three-level OptiX graph.

Gated on `CYCLES_NESTED_SHARED` rather than a UI option, and read fresh at each
sync — so it can be flipped on and off inside one session.

## Solid/EEVEE viewports off

Independent of the other two, and useful with or without them. It culls the
whole dupli set in one decision, so the rasterised viewport never generates the
instances at all.

## Is it correct

Rendering with the feature off and on inside one Blender session gives
byte-identical output where it should. Normal, True Normal and Position probes:
zero differing channels. The scene seen from the light: zero.

What's still to do is listed at the bottom of the README.

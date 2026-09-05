# Cycles nested instancing — Blender 5.2

Three separate switches. **NVIDIA RTX only** (OptiX), Windows.

| | switched by | what it gives you |
|---|---|---|
| Render instances directly | per-object checkbox | faster sync on big scatters |
| Nested instancing | environment variable | the memory win — needs the above |
| Solid/EEVEE viewports off | per-object checkbox | bonus for very heavy scatters |

## Setup

1. Download the zip from [Releases](../../releases) and unzip it.
2. Put `run-with-nested-instancing.cmd` next to `blender.exe` and start Blender
   with it. It sets `CYCLES_NESTED_SHARED=1`, which is what turns nesting on.
3. On each scattering object: **Object Properties → Visibility → Render
   Instances Directly**.

## What each one does

**Render instances directly** — step 3, per object. Cycles reads
geometry-nodes instances straight from the evaluated geometry instead of having
the depsgraph expand them into real duplicates first. A speedup in its own
right: big scatters sync, and re-sync after every edit, far faster. Also the
foundation nesting is built on.

Works on collection instances too. Tick it on the empty and the whole
collection is read directly, including collection instances nested inside it.

**Nested instancing** — step 2, the environment variable. Stops Cycles
flattening scattered geometry into one record per leaf per tree. 210 trees ×
100,172 leaves — 21 million instances from **38 MB instead of 7.1 GB**. Only
applies to objects that have the toggle above.

**Solid/EEVEE viewports off** — optional, same panel under **Show In**. The
normal viewport builds real geometry for every instance and will stall or run
out of memory long before Cycles would. Untick it and the object vanishes from
the Solid, Wireframe and EEVEE viewports while still rendering in Cycles.
Select it from the Outliner while it's hidden.

## Or build it yourself

```
git clone https://projects.blender.org/blender/blender.git
cd blender
git checkout v5.2.0
make update
git apply path/to/cycles-nested-instancing.patch
cmake -S . -B ../build -G "Visual Studio 17 2022" -A x64 -DWITH_CYCLES_DEVICE_OPTIX=ON
cmake --build ../build --config Release --target INSTALL --parallel 4
```

Visual Studio 2022, CUDA 13.3, OptiX 9.1.0.

GPL, like Blender. Patch applies to Blender `v5.2.0` (`fbe6228777e7`).
See `EXPLAINER-nested-instancing.md`.

## Since the first release

- Collection instances work. Ticking the box on one used to make it disappear,
  and a collection instance nested inside an instanced collection was dropped
  even with the box left alone.
- Moving a collection instance during a render updates it live, instead of
  waiting for the render to restart.
- Geometry-nodes instances no longer render black with the box ticked.
- Box-select, and the other viewport passes, respect the Solid/EEVEE toggle.
  Selecting over a heavy scatter went from about 850 ms to 4 ms.
- Groups and prototypes are kept between viewport updates rather than rebuilt,
  so moving the camera over a heavy scatter costs ~14 ms instead of ~141 ms.
- Several crashes fixed: removing an object from an instanced collection,
  deleting an instancer mid-render, and instancer data being matched to the
  wrong object after an undo.

## Left to do

- [ ] **CPU path.** The bundled Embree allows one level of instancing, so
      nesting is OptiX-only. Needs an Embree built for more levels.
- [ ] **Emissive and volume prototypes.** One of either disables nesting for the
      whole scene. Lights are indexed per object and sampled in world space, and
      a group member has neither an object nor a world transform of its own.
- [ ] **Test on macOS and Linux.** Built and tested on Windows only.
- [ ] **Bake the features in.** Drop the environment variable and the per-object
      opt-in once they've earned it, so this is just how Cycles works.
- [ ] **Move the viewport toggle into geometry nodes.** An `Is Cycles` output
      alongside `Is Viewport`, or a control on `Is Viewport` itself — closer to
      how Blender already does this than a per-object visibility flag.
- [ ] Motion blur with groups is untested.

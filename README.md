# Cycles nested instancing — Blender 5.2

Cycles renders scattered geometry without flattening it. 210 trees × 100,172
leaves — 21 million instances from **38 MB instead of 7.1 GB**.

**NVIDIA RTX only** (OptiX), Windows.

## Use the prebuilt Blender

1. Download the zip from [Releases](../../releases) and unzip it.
2. Put `run-with-nested-instancing.cmd` next to `blender.exe`, and start Blender
   with it.
3. On each scattering object: **Object Properties → Visibility → Render
   Instances Directly**.

Step 3 is required, per object. Without it that object renders the ordinary way.

Optional, same panel under **Show In**: untick **Solid/EEVEE Viewports**. The
object vanishes from the Solid, Wireframe and EEVEE viewports but still renders
in Cycles — use it when a scatter is too heavy for the normal viewport.

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

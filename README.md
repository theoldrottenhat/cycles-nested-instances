# Cycles nested instancing — Blender 5.2

Cycles renders scattered geometry without flattening it. A forest costs one
tree's worth of memory plus a small record per tree.

Measured: 210 trees × 100,172 leaves — 21,036,330 instances rendering from
**38 MB instead of 7.1 GB**.

**NVIDIA RTX only** (OptiX), Windows. No CPU path, no macOS.

## Use the prebuilt Blender

1. Download the zip from [Releases](../../releases) and unzip it.
2. Copy `run-with-nested-instancing.cmd` from this repo next to `blender.exe`,
   and start Blender with it.
3. On each scattering object: Object Properties → Custom Properties → add
   `cycles_render_instancer`, set it to `True`.

Without step 2 or 3 Blender runs normally and the feature does nothing.

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

Built and tested with Visual Studio 2022, CUDA 13.3, OptiX 9.1.0.

## More

`EXPLAINER-nested-instancing.md` — how it works and what it can't do yet.

GPL, like Blender. Patch applies to Blender `v5.2.0` (`fbe6228777e7`).

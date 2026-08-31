@echo off
REM Put this next to blender.exe and run it instead of blender.exe.
set CYCLES_NESTED_SHARED=1
start "" "%~dp0blender.exe" %*

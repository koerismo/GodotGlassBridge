# Godot Glass Bridge
Allows Godot 4.3+ to be used with newer Looking Glass devices via the Looking Glass Bridge SDK.

### Information

Much of the interfacing code was written by John Wigg, and this library primarily serves to port it to use the newer Glass Bridge SDK rather than the HoloPlayCore SDK. The library is a **WORK IN PROGRESS** and currently does not build correctly due to linking shenanigans. Use GodotHoloPlay instead of this!

### Building

```
cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
cmake --build .
```

# Emulator
a version ported to windows
run build.bat to build it, if you are using 32-bit system, then you need to change the libraries in build.bat to the correspoding 32 bit versions
the dlls needed by the program is in the dlls directory

The memory editor is modified so the SFRs are now accesible.
Edit src/Gui/Commands.cpp if you want to change the range of the memory editor.

Note:Functions about `0xF404` and `0xF405` are not simulated as they seem to be never called in Casio calculators.

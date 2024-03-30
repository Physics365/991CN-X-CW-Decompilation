#pragma once
#include "../Emulator.hpp"
#include "../Chipset/MMU.hpp"
#include "CodeViewer.hpp"
int test_gui(bool* guiCreated);
void gui_cleanup();
void gui_loop();
extern char *n_ram_buffer;
extern casioemu::MMU* me_mmu;
extern casioemu::Emulator *m_emu;
extern CodeViewer *code_viewer;
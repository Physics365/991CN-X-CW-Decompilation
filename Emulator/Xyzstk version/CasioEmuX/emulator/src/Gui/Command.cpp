// #include <X11/Xlib.h>
#include <cstddef>
#include "imgui/imgui.h"
#include "CodeViewer.hpp"
#include "SDL_timer.h"
#include "imgui/imgui_impl_sdl2.h"
#include "imgui/imgui_impl_sdlrenderer2.h"
#include <SDL.h>
#include <iostream>
#include "ui.hpp"
#include "../Chipset/MMU.hpp"

#include "hex.hpp"

char *n_ram_buffer=nullptr;
casioemu::MMU *me_mmu = nullptr;
CodeViewer *code_viewer=nullptr;
static SDL_WindowFlags window_flags = (SDL_WindowFlags)(SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI);
static SDL_Window* window;
static SDL_Renderer* renderer;
static ImVec4 clear_color = ImVec4(0.45f, 0.55f, 0.60f, 1.00f);
void gui_loop(){
    if(!m_emu->Running())
        return;

    //cv.LookUp(1, 0x1235);
    ImGuiIO& io = ImGui::GetIO();
    
    ImGui_ImplSDLRenderer2_NewFrame();
    ImGui_ImplSDL2_NewFrame();
    ImGui::NewFrame();
    
    static MemoryEditor mem_edit;
    if(n_ram_buffer!=nullptr&&me_mmu!=nullptr){
        //std::cout<<"renderhex!";
        mem_edit.DrawWindow(me_mmu,"Memory Editor", n_ram_buffer, 0x7000,0x9000);
    }
    code_viewer->DrawWindow();
    

    // Rendering
    ImGui::Render();
    SDL_RenderSetScale(renderer, io.DisplayFramebufferScale.x, io.DisplayFramebufferScale.y);
    SDL_SetRenderDrawColor(renderer, (Uint8)(clear_color.x * 255), (Uint8)(clear_color.y * 255), (Uint8)(clear_color.z * 255), (Uint8)(clear_color.w * 255));
    SDL_RenderClear(renderer);
    ImGui_ImplSDLRenderer2_RenderDrawData(ImGui::GetDrawData());
    SDL_RenderPresent(renderer);
}
int test_gui(bool* guiCreated){
    //SDL_Delay(1000*5);
    window = SDL_CreateWindow("CasioEmuX", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1280, 720, window_flags);
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED);
    if (renderer == nullptr)
    {
        SDL_Log("Error creating SDL_Renderer!");
        return 0;
    }
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO();
    io.WantCaptureKeyboard=true;
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;     // Enable Keyboard Controls
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableGamepad;      // Enable Gamepad Controls
    io.FontGlobalScale = 1.0;
    //io.WantTextInput = true;
    //io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;         // IF using Docking Branch
    
    // Setup Platform/Renderer backends
    ImGui::StyleColorsDark();
    //ImGui::StyleColorsLight();

    // Setup Platform/Renderer backends
    ImGui_ImplSDL2_InitForSDLRenderer(window, renderer);
    ImGui_ImplSDLRenderer2_Init(renderer);
    // bool show_demo_window = true;
    // bool show_another_window = false;
    // char buf[100]{0};
    // Main loop
    // bool done = false;

    *guiCreated = true;
    while(!m_emu)
        ;
    code_viewer=new CodeViewer(m_emu->GetModelFilePath("_disas.txt"));

    return 0;
    //ImGui_ImplSDL2_InitForSDLRenderer(renderer);
}

void gui_cleanup(){
        // Cleanup
    ImGui_ImplSDLRenderer2_Shutdown();
    ImGui_ImplSDL2_Shutdown();
    ImGui::DestroyContext();

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}

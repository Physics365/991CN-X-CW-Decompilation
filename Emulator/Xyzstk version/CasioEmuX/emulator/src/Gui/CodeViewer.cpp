#include "CodeViewer.hpp"
#include "../Chipset/CPU.hpp"
#include "../Chipset/Chipset.hpp"
#include "../Config.hpp"
#include "../Emulator.hpp"
#include "../Logger.hpp"
#include "imgui/imgui.h"
#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <fstream>
#include <ios>
#include <iostream>
#include <ostream>
#include <string>
#include <thread>
casioemu::Emulator *m_emu = nullptr;
CodeViewer::CodeViewer(std::string path) {
    src_path = path;
    std::thread t1([this]() {
        std::ifstream f(src_path, std::ios::in);
        if (!f.is_open()) {
            PANIC("\nFail to open disassembly code src: %s\n", src_path.c_str());
        }
        casioemu::logger::Info("Start to read code src ...\n");
        char buf[200]{0};
        char adr[6]{0};
        while (!f.eof()) {
            f.getline(buf, 200);
            // 1sf, extract segment number
            uint8_t seg = buf[1] - '0';
            uint8_t len = strlen(buf);
            if (!len)
                break;
            if (len > max_col)
                max_col = len;
            memcpy(adr, buf + 2, 4);
            // casioemu::logger::Info("[%s %d %d]\n",adr,seg,len);
            uint16_t offset = std::stoi(adr, 0, 16);
            CodeElem e;
            e.offset = offset;
            e.segment = seg;
            memset(e.srcbuf, 0, 40);
            memcpy(e.srcbuf, buf + 28, len - 28);
            codes.push_back(e);
            memset(buf, 0, 200);
            memset(adr, 0, 6);
        }
        f.close();
        casioemu::logger::Info("Read src codes over!\n");
        max_row = codes.size();
        is_loaded = true;
    });
    t1.join();
}
bool elem_cmp(const CodeElem &a, const CodeElem &b) {
    return a.segment == b.segment && a.offset < b.offset;
}

CodeViewer::~CodeViewer() {
}

CodeElem CodeViewer::LookUp(uint8_t seg, uint16_t offset, int *idx) {
    // binary search
    CodeElem target;
    target.offset = offset;
    target.segment = seg;
    auto it = std::lower_bound(codes.begin(), codes.end(), target, elem_cmp);
    if (it == codes.end()) {
        it = codes.begin();
        // casioemu::logger::Info("fFound element ! at: %d seg, %x off %s\n",it->segment,it->offset,it->srcbuf);
    }
    if (idx)
        *idx = it - codes.begin();
    return {.segment = it->segment, .offset = it->offset};
}

bool CodeViewer::TryTrigBP(uint8_t seg, uint16_t offset, bool bp_mode) {
    for (auto it = break_points.begin(); it != break_points.end(); it++) {
        if (it->second == 1) {
            // TODO: We ignore a second trigger
            CodeElem e = codes[it->first];
            if (e.segment == seg && e.offset == offset) {
                break_points[it->first] = 2;
                cur_col = it->first;
                need_roll = true;
                return true;
            }
        }
    }
    if (!bp_mode && (debug_flags & DEBUG_STEP || debug_flags & DEBUG_RET_TRACE)) {
        int idx = 0;
        LookUp(seg, offset, &idx);
        break_points[idx] = 2;
        cur_col = idx;
        need_roll = true;
        return true;
    }
    return false;
}

void CodeViewer::DrawContent() {
    ImGuiListClipper c;
    c.Begin(max_row, ImGui::GetTextLineHeight());
    ImDrawList *draw_list = ImGui::GetWindowDrawList();
    (void)draw_list;
    while (c.Step()) {
        for (int line_i = c.DisplayStart; line_i < c.DisplayEnd; line_i++) {
            CodeElem e = codes[line_i];
            auto it = break_points.find(line_i);
            if (it == break_points.end()) {
                ImGui::Text("[ o ]");
                if (ImGui::IsItemHovered() && ImGui::IsMouseClicked(0)) {
                    break_points[line_i] = 1;
                }
            } else {
                if (it->second == 1) {
                    ImGui::TextColored(ImVec4(1.0, 0.0, 0.0, 1.0), "[ x ]");
                    if (ImGui::IsItemHovered() && ImGui::IsMouseClicked(0)) {
                        break_points.erase(line_i);
                    }
                } else {
                    ImGui::TextColored(ImVec4(0.0, 1.0, 0.0, 1.0), "[ > ]");
                    // the break point is triggered!
                    ImGui::SameLine();
                    if (ImGui::Button("Continue?")) {
                        break_points.erase(line_i);
                        m_emu->SetPaused(false);
                    }
                }
            }
            ImGui::SameLine();
            ImGui::TextColored(ImVec4(1.0, 1.0, 0.0, 1.0), "%d:%04x", e.segment, e.offset);
            ImGui::SameLine();
            if (selected_addr != (uint32_t)e.segment * 0x10000 + e.offset) {
                ImGui::Text("%s", e.srcbuf);
                if (ImGui::IsItemHovered() && ImGui::IsMouseClicked(0)) {
                    selected_addr = e.segment * 0x10000 + e.offset;
                    cur_col = line_i;
                    edit_active = true;
                }
            } else {
                if (edit_active) {
                    ImGui::InputText("##data", e.srcbuf, strlen(e.srcbuf), ImGuiInputTextFlags_ReadOnly | ImGuiInputTextFlags_AlwaysOverwrite);
                    // ImGui::SetKeyboardFocusHere();
                    //  if(!ImGui::IsItemActive())
                    //  {
                    //      edit_active=false;
                    //  }
                    if (ImGui::IsWindowFocused()) {
                        if (ImGui::IsKeyPressed(ImGui::GetKeyIndex(ImGuiKey_DownArrow))) {
                            cur_col++;
                            if (cur_col >= max_row)
                                cur_col = max_row;
                            need_roll = true;
                        } else if (ImGui::IsKeyPressed(ImGui::GetKeyIndex(ImGuiKey_UpArrow))) {
                            cur_col--;
                            if (cur_col < 0)
                                cur_col = 0;
                            need_roll = true;
                        }
                    }
                }
            }
        }
    }
    if (need_roll) {
        float v = (float)cur_col / max_row * ImGui::GetScrollMaxY();
        ImGui::SetScrollY(v);
        need_roll = false;
        selected_addr = codes[cur_col].segment * 0x10000 + codes[cur_col].offset;
    }
}

void CodeViewer::DrawMonitor() {
    if (m_emu != nullptr) {
        casioemu::Chipset &chipset = m_emu->chipset;
        std::string s = chipset.cpu.GetBacktrace();
        ImGui::InputTextMultiline("##as", (char *)s.c_str(), s.size(), ImVec2(ImGui::GetWindowWidth(), 0), ImGuiInputTextFlags_ReadOnly);
    }
}

static bool step_debug = false, trace_debug = false;

void CodeViewer::DrawWindow() {

    int h = ImGui::GetTextLineHeight() + 4;
    int w = ImGui::CalcTextSize("F").x;
    if (!is_loaded) {
        ImGui::SetNextWindowSize(ImVec2(w * 50, h * 10), ImGuiCond_FirstUseEver);
        ImGui::SetNextWindowContentSize(ImVec2(w * 50, h * 10));
        ImGui::Begin("Disassemble Window");
        ImGui::SetCursorPos(ImVec2(w * 2, h * 5));
        ImGui::Text("Please wait loading...");
        ImGui::End();
        return;
    }
    ImVec2 sz;
    h *= 10;
    w *= max_col;
    sz.x = w;
    sz.y = h;
    // ImGui::SetNextWindowSize(sz);
    // ImGui::SetNextWindowContentSize(sz);
    ImGui::Begin("Disassemble Window", 0);
    ImGui::BeginChild("##scrolling", ImVec2(0, -ImGui::GetWindowHeight() / 2));
    DrawContent();
    ImGui::EndChild();
    ImGui::Separator();
    ImGui::Text("Go to Addr:");
    ImGui::SameLine();
    ImGui::SetNextItemWidth(ImGui::CalcTextSize("000000").x);
    ImGui::InputText("##input", adrbuf, 8);
    if (adrbuf[0] != '\0' && ImGui::IsItemFocused()) {
        uint32_t addr = std::stoi(adrbuf, 0, 16);
        JumpTo(addr >> 16, addr & 0x0ffff);
    }
    ImGui::SameLine();
    ImGui::Checkbox("STEP", &step_debug);
    ImGui::SameLine();
    ImGui::Checkbox("TRACE", &trace_debug);

    // ImGui::BeginChild("##scrolling");
    DrawMonitor();
    // ImGui::EndChild();
    ImGui::End();
    debug_flags = DEBUG_BREAKPOINT | (step_debug ? DEBUG_STEP : 0) | (trace_debug ? DEBUG_RET_TRACE : 0);
}

void CodeViewer::JumpTo(uint8_t seg, uint16_t offset) {
    int idx = 0;
    // printf("jumpto:seg%d\n",seg);
    LookUp(seg, offset, &idx);
    cur_col = idx;
    need_roll = true;
}

/*
DingusPPC - The Experimental PowerPC Macintosh emulator
Copyright (C) 2018-23 divingkatae and maximum
                      (theweirdo)     spatium

(Contact divingkatae#1017 or powermax#2286 on Discord for more info)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

/** @file Platform-specific main functions. */

bool init();
void cleanup();

#ifndef DINGUSPPC_MAIN_H
#define DINGUSPPC_MAIN_H

#include <cinttypes>
#include <csignal>
#include <cstring>
#include <iostream>
#include <memory>
#include <string>

#include "CLI11.hpp"
#include "loguru.hpp"
#include "core/hostevents.h"
#include "core/timermanager.h"
#include "cpu/ppc/ppcdisasm.h"
#include "cpu/ppc/ppcemu.h"
#include "cpu/ppc/ppcmmu.h"
#include "debugger/debugger.h"
#include "machines/machinebase.h"
#include "machines/machinefactory.h"
#include "utils/profiler.h"

#ifdef _WIN32
#include <direct.h>
#else
#include <unistd.h>
#endif

// Namespace
using namespace std;

// Constants
extern const std::string appDescription;

// Globals
extern bool power_on;
extern bool is_deterministic;
extern std::unique_ptr<class Profiler> gProfilerObj;
extern std::unique_ptr<class MachineBase> gMachineObj;

// Functions
void run_machine(std::string machine_str, char *rom_data, size_t rom_size, uint32_t execution_mode,
                 uint32_t profiling_interval_ms = 0);
int main2(int argc, char** argv);

void startDebugger();

#endif // DINGUSPPC_MAIN_H

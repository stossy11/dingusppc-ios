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



#include <Cocoa/Cocoa.h>

@file SDL-specific main function additions for macOS hosts. 

// Replace Command shortcuts with Control shortcuts in the menu bar, so that
// they're not going to conflict with ones in the guest OS (but we still allow
// some of them to be used in the host OS, e.g. Control+Q to quit).
void remap_appkit_menu_shortcuts(void) {
    for (NSMenuItem *menuItem in [NSApp mainMenu].itemArray) {
        if (menuItem.hasSubmenu) {
            for (NSMenuItem *item in menuItem.submenu.itemArray) {
                if (item.keyEquivalentModifierMask & NSEventModifierFlagCommand) {
                    item.keyEquivalentModifierMask &= ~NSEventModifierFlagCommand;
                    item.keyEquivalentModifierMask |= NSEventModifierFlagControl;
                }
            }
        }
    }
}
*/

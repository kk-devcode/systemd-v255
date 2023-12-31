/* SPDX-License-Identifier: LGPL-2.1-or-later */
#pragma once

#include <stdbool.h>

#define KBD_KEYMAP_DIRS                         \
        "/usr/share/keymaps/\0"                 \
        "/usr/share/kbd/keymaps/\0"             \
        "/usr/lib/kbd/keymaps/\0"

int get_keymaps(char ***l);
bool keymap_is_valid(const char *name);
int keymap_exists(const char *name);

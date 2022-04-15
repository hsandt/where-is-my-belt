#!/usr/bin/env python3.6
# -*- coding: utf-8 -*-

# Define game-specific namespaced and free constants in the two dict below

# ! When possible, prefer defining constants in some module table returned at the end of the file
# ! and add this file to game_constant_module_paths_string in build_single_cartridge.sh

# Whether you use the substitute tables or game_constant_module_paths_string,
# we recommend to strip the constants by surrounding them with `--#if game_constants` and `--#endif`

# table of symbol substitutes specific to the game
# complements the generic engine symbol substitute table in replace_strings.py
# format: { namespace1: {name1: substitute1, name2: substitute2, ...}, ... }
GAME_SYMBOL_SUBSTITUTE_TABLE = {
}


# table of constants specific to the game
# complements the generic engine arg substitute table in replace_strings.py
# format: {name1: value1, name2: value2, ...}
GAME_CONSTANT_SUBSTITUTE_TABLE = {
}

-- Require all common modules for cartridge: core
-- All the required modules must define globals and not return a module table.

-- Usage: add `require("common_{cartridge}")` at the top of:
--  - main_{cartridge}.lua
--  - itest_main_{cartridge}.lua
--  - bustedhelper_{cartridge}.lua
--  just after their engine counterpart.

-- Common modules
require("engine/core/fun_helper")
require("engine/core/math_round")  -- used by string_format_number
require("engine/core/string_format_number")

--#if minify_level3

-- Modules that just need early require for global name minification
require("engine/core/string_split")

--#endif

--[[#pico8
--#if unity
-- When doing a unity build, all modules must be concatenated in dependency, with modules relied upon
--  above modules relying on them.
-- This matters for two reasons:
--  1. Some statements are done in outer scope and rely on other modules (derived_class(), data tables defining
--   sprite_data(), table merge(), etc.) so the struct/class/function used must be defined at evaluation time,
--   and there is no picotool package definition callback wrapper to delay package evaluation to main evaluation
--   time (which is done at the end).
--  2. Even in inner scope (method calls), statements refer to named modules normally stored in local vars via
--     require. In theory, *declaring* the local module at the top of whole file and defining it at runtime
--     at any point before main is evaluation would be enough, but it's cumbersome to remove "local" in front
--     of the local my_module = ... inside each package definition, so we prefer reordering the packages
--     so that the declaration-definition is always above all usages.
-- Interestingly, ordered_require will contain the global requires in this very file (keeping same order)
--  for minification lvl3, but it redundancy doesn't matter as all require calls will be stripped.

require("ordered_require_core")

--#endif
--#pico8]]

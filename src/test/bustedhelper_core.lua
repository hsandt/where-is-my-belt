-- Required module for utests testing any module of game cartridge: core
-- It adds common modules for {cartridge}, since the original bustedhelper.lua
--  is part of engine and therefore cannot reference game modules
-- Usage:
--  in your game utests, always require("test/bustedhelper_{cartridge}") at the top
--  instead of "engine/test/bustedhelper"
require("engine/test/bustedhelper")
require("common_core")

-- uncomment below just when you need to see log during utests
--[[
local logging = require("engine/debug/logging")
logging.logger:register_stream(logging.console_log_stream)
logging.logger.active_categories = {
  -- engine
  ['default'] = true,
  -- ['codetuner'] = true,
  -- ['flow'] = true,
  -- ['itest'] = true,
  -- ['log'] = true,
  -- ['ui'] = true,
  -- ['reload'] = true,
  ['trace'] = true,
  ['trace2'] = true,
  -- ['frame'] = true,

  -- game
  -- ['...'] = true,
}
--]]

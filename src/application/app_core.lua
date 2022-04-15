-- base class for custom game application
-- derive it for each cartridge

local gameapp = require("engine/application/gameapp")
local input = require("engine/input/input")

--#if tuner
local codetuner = require("engine/debug/codetuner")
--#endif

--#if profiler
local profiler = require("engine/debug/profiler")
--#endif

--#if visual_logger
local vlogger = require("engine/debug/visual_logger")
--#endif

--#if mouse
local mouse = require("engine/ui/mouse")
--#endif

--#if profiler_lightweight
local outline = require("engine/ui/outline")
--#endif

local ingame_state = require("ingame/ingame_state")
local main_menu_state = require("menu/main_menu_state")
local visual = require("resources/visual")

local app_core = derived_class(gameapp)

function app_core:init()
  gameapp.init(self, fps60)
end

function app_core:instantiate_gamestates() -- override (mandatory)
  return {main_menu_state(), ingame_state()}
end

function app_core:on_pre_start() -- override (optional)
  -- #title
  extcmd("set_title","Where is my Belt?")

--#ifn itest
  -- cartdata is meant for saving and must only be called once by the program
  -- itest are not supposed to save anything, and simulate multiple app instances to isolate tests,
  --  which would cause an error on the second call to cartdata; so exclude this from itest
  -- #title
  cartdata("komehara_where-is-my-belt")
--#endif

  -- disable input auto-repeat (this is to be cleaner, as input module barely uses btnp anyway,
  --  and simply detects state changes using btn; if too many compressed chars, strip that first)
  poke(0x5f5c, -1)

--#if mouse
  -- enable mouse devkit
  input:toggle_mouse(true)
  mouse:set_cursor_sprite_data(visual.sprite_data_t.cursor)
--#endif
end

function app_core:on_post_start() -- override (optional)
  menuitem(4, "retry", function()
    -- for now, just reload cartridge
    -- prefer passing basename for compatibility with .p8.png
    load('where-is-my-belt_core')
  end)

  menuitem(5, "back to title", function()
    -- for now, just reload cartridge
    -- prefer passing basename for compatibility with .p8.png
    load('where-is-my-belt_core')
  end)
end

--#if itest
function app_core:on_reset() -- override
--#if mouse
  mouse:set_cursor_sprite_data(nil)
--#endif
end
--#endif

-- Note that if you add support for 2+ OR statements in preprocess.py, it will be more correct
--  to use `--#if profiler || visual_logger || tuner` so non-release builds that don't use those
--  don't define on_update either; but the most important is to strip code from release anyway.
-- Same remark for on_render below
--#ifn release
function app_core:on_update() -- override
--#if profiler
  profiler.window:update()
--#endif

--#if visual_logger
  vlogger.window:update()
--#endif

--#if tuner
  codetuner:update_window()
--#endif
end
--#endif

--#ifn release
function app_core:on_render() -- override
  printh("on_render")

--#if profiler
  profiler.window:render()
--#endif

--#if visual_logger
  vlogger.window:render()
--#endif

--#if tuner
  codetuner:render_window()
--#endif

--#if mouse
  -- always draw cursor on top of the rest (except for profiling)
  mouse:render()
--#endif

--#if profiler_lightweight
  -- when profiler is too heavy due to the whole UI module it uses, use this
  -- it is drawn after the rest so it can take mouse render into account if used in real game
  -- print total CPU
  outline.print_with_outline("cpu: "..stat(1), 2, 10, colors.orange, colors.black)
--#endif
end
--#endif

return app_core

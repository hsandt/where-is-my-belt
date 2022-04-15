require("engine/test/bustedhelper")  -- no specific cartridge, so just use the engine version
local app_core = require("application/app_core")

local flow = require("engine/application/flow")
local codetuner = require("engine/debug/codetuner")
local profiler = require("engine/debug/profiler")
local vlogger = require("engine/debug/visual_logger")
local input = require("engine/input/input")
local mouse = require("engine/ui/mouse")

local ingame_state = require("ingame/ingame_state")
local main_menu_state = require("menu/main_menu_state")
local visual = require("resources/visual")

describe('app_core', function ()

  local app

  before_each(function ()
    app = app_core()
  end)

  describe('instantiate_gamestates', function ()

    it('should return all gamestates', function ()
      assert.are_same({main_menu_state(), ingame_state()}, app_core:instantiate_gamestates())
    end)

  end)

  describe('on_pre_start', function ()

    setup(function ()
      stub(_G, "extcmd")
      stub(_G, "cartdata")
      stub(input, "toggle_mouse")
      stub(mouse, "set_cursor_sprite_data")
    end)

    teardown(function ()
      extcmd:revert()
      cartdata:revert()
      input.toggle_mouse:revert()
      mouse.set_cursor_sprite_data:revert()
    end)

    after_each(function ()
      clear_table(pico8.poked_addresses)

      extcmd:clear()
      cartdata:clear()
      input.toggle_mouse:clear()
      mouse.set_cursor_sprite_data:clear()
    end)

    it('should set title to "Where is my Belt?" using extcmd', function ()
      app:on_pre_start()
      assert.spy(extcmd).was_called(1)
      assert.spy(extcmd).was_called_with("set_title", "Where is my Belt?")
    end)

    it('should cartdata name to "komehara_where-is-my-belt"', function ()
      app:on_pre_start()
      assert.spy(cartdata).was_called(1)
      assert.spy(cartdata).was_called_with("komehara_where-is-my-belt")
    end)

    it('should disable input auto-repeat by poking 0x5f5c = 255 (-1)', function ()
      app:on_pre_start()
      assert.are_equal(-1, pico8.poked_addresses[0x5f5c])
    end)

    it('should toggle mouse cursor', function ()
      app:on_pre_start()
      assert.spy(input.toggle_mouse).was_called(1)
      assert.spy(input.toggle_mouse).was_called_with(match.ref(input), true)
    end)

    it('should set the mouse cursor sprite data', function ()
      app:on_pre_start()
      assert.spy(mouse.set_cursor_sprite_data).was_called(1)
      assert.spy(mouse.set_cursor_sprite_data).was_called_with(match.ref(mouse), match.ref(visual.sprite_data_t.cursor))
    end)

  end)

  describe('on_post_start', function ()

    setup(function ()
      stub(_G, "menuitem")
    end)

    teardown(function ()
      menuitem:revert()
    end)

    after_each(function ()
      menuitem:clear()
    end)

    it('should create 2 menu items', function ()
      app:on_post_start()
      assert.spy(menuitem).was_called(2)
      -- no reference to lambda passed to menuitem, so don't test was_called_with
    end)

  end)

  describe('on_reset', function ()

    setup(function ()
      stub(mouse, "set_cursor_sprite_data")
    end)

    teardown(function ()
      mouse.set_cursor_sprite_data:revert()
    end)

    after_each(function ()
      mouse.set_cursor_sprite_data:clear()
    end)

    it('should reset the mouse cursor sprite data', function ()
      app_core:on_reset()
      local s = assert.spy(mouse.set_cursor_sprite_data)
      s.was_called(1)
      s.was_called_with(match.ref(mouse), nil)
    end)

  end)

  describe('on_update', function ()

    setup(function ()
      stub(vlogger.window, "update")
      stub(profiler.window, "update")
      stub(codetuner, "update_window")
    end)

    teardown(function ()
      vlogger.window.update:revert()
      profiler.window.update:revert()
      codetuner.update_window:revert()
    end)

    after_each(function ()
      vlogger.window.update:clear()
      profiler.window.update:clear()
      codetuner.update_window:clear()
    end)

    it('should update the vlogger window', function ()
      app_core:on_update()
      local s = assert.spy(vlogger.window.update)
      s.was_called(1)
      s.was_called_with(match.ref(vlogger.window))
    end)

    it('should update the profiler window', function ()
      app_core:on_update()
      local s = assert.spy(profiler.window.update)
      s.was_called(1)
      s.was_called_with(match.ref(profiler.window))
    end)

    it('should update the codetuner window', function ()
      app_core:on_update()
      local s = assert.spy(codetuner.update_window)
      s.was_called(1)
      s.was_called_with(match.ref(codetuner))
    end)

  end)

  describe('on_render', function ()

    setup(function ()
      stub(vlogger.window, "render")
      stub(profiler.window, "render")
      stub(codetuner, "render_window")
      stub(mouse, "render")
    end)

    teardown(function ()
      vlogger.window.render:revert()
      profiler.window.render:revert()
      codetuner.render_window:revert()
      mouse.render:revert()
    end)

    after_each(function ()
      vlogger.window.render:clear()
      profiler.window.render:clear()
      codetuner.render_window:clear()
      mouse.render:clear()
    end)

    it('should render the vlogger window', function ()
      app_core:on_render()
      local s = assert.spy(vlogger.window.render)
      s.was_called(1)
      s.was_called_with(match.ref(vlogger.window))
    end)

    it('should render the profiler window', function ()
      app_core:on_render()
      local s = assert.spy(profiler.window.render)
      s.was_called(1)
      s.was_called_with(match.ref(profiler.window))
    end)

    it('should render the codetuner window', function ()
      app_core:on_render()
      local s = assert.spy(codetuner.render_window)
      s.was_called(1)
      s.was_called_with(match.ref(codetuner))
    end)

    it('should render the mouse', function ()
      app_core:on_render()
      local s = assert.spy(mouse.render)
      s.was_called(1)
      s.was_called_with(match.ref(mouse))
    end)

  end)

end)

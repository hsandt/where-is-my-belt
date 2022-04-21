require("test/bustedhelper_core")
local main_menu_state = require("menu/main_menu_state")

local gamestate = require("engine/application/gamestate")
local input = require("engine/input/input")
require("engine/render/color")
local text_helper = require("engine/ui/text_helper")

local menu = require("menu/menu_with_sfx")

describe('main_menu_state', function ()

  describe('class', function ()
    it('should derive from gamestate', function ()
      assert.are_equal(gamestate, getmetatable(main_menu_state).__index)
    end)
  end)

  describe('instance', function ()

    describe('init', function ()
      it('should initialize members', function ()
        local mms = main_menu_state()
        assert.are_equal(1, #mms.items)
      end)
    end)

    describe('(with instance)', function ()

      local mms

      before_each(function ()
        mms = main_menu_state()
      end)

      describe('update', function ()

        setup(function ()
          stub(menu, "update")
        end)

        teardown(function ()
          menu.update:revert()
        end)

        it('should update menu when present', function ()
          mms.menu = menu()

          mms:update()

          local s = assert.spy(menu.update)
          s.was_called(1)
          s.was_called_with(match.ref(mms.menu))
        end)

      end)

      describe('render', function ()

        setup(function ()
          stub(text_helper, "print_centered")
          -- stub menu.draw completely to avoid altering the count of text_helper.print_centered calls
          stub(menu, "draw")
        end)

        teardown(function ()
          text_helper.print_centered:revert()
          menu.draw:revert()
        end)

        after_each(function ()
          text_helper.print_centered:clear()
          menu.draw:clear()
        end)

        it('should not crash', function ()
          mms:render()
        end)

      end)

    end)

  end)  -- instance

end)

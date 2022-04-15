require("engine/test/bustedhelper")
local ingame_state = require("ingame/ingame_state")

local gamestate = require("engine/application/gamestate")
local input = require("engine/input/input")
require("engine/render/color")
local text_helper = require("engine/ui/text_helper")

describe('ingame_state', function ()

  describe('class', function ()
    it('should derive from gamestate', function ()
      assert.are_equal(gamestate, getmetatable(ingame_state).__index)
    end)
  end)

  describe('instance', function ()

    describe('init', function ()
    end)

    describe('(with instance)', function ()

      local igs

      before_each(function ()
        igs = ingame_state()
      end)

      describe('update', function ()
      end)

      describe('render', function ()

        setup(function ()
          stub(text_helper, "print_centered")
          -- stub text_igs.draw completely to avoid altering the count of text_helper.print_centered calls
        end)

        teardown(function ()
          text_helper.print_centered:revert()
        end)

        after_each(function ()
          text_helper.print_centered:clear()
        end)

        it('should print "main igs" centered, in white', function ()
          igs:render()

          local s = assert.spy(text_helper.print_centered)
          s.was_called(1)
          s.was_called_with("ingame", 64, 48, colors.white)
        end)

      end)

    end)

  end)  -- instance

end)

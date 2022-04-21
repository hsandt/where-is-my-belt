require("test/bustedhelper_core")
local credits = require("menu/credits")

local menu = require("menu/menu")

describe('credits', function ()

  describe('(with instance)', function ()

    local fake_app = {}
    local c

    before_each(function ()
      c = credits()
      c.app = fake_app
    end)

    describe('on_enter', function ()

      setup(function ()
        stub(_G, "music")
        stub(menu, "show_items")
      end)

      teardown(function ()
        music:revert()
        menu.show_items:revert()
      end)

      before_each(function ()
        c = credits()
        c.app = fake_app
      end)

      after_each(function ()
        music:clear()
        menu.show_items:clear()
      end)

    end)

    describe('(with menu entered)', function ()

      before_each(function ()
        c:on_enter()
      end)

      describe('update', function ()

        setup(function ()
          stub(menu, "update")
        end)

        teardown(function ()
          menu.update:revert()
        end)

        it('should update menu', function ()
          c:update()

          assert.spy(menu.update).was_called(1)
          assert.spy(menu.update).was_called_with(match.ref(c.menu))
        end)

      end)

      describe('render', function ()

        setup(function ()
          stub(credits, "draw_credits_text")
          stub(menu, "draw")
        end)

        teardown(function ()
          credits.draw_credits_text:revert()
          menu.draw:revert()
        end)

        after_each(function ()
          credits.draw_credits_text:clear()
          menu.draw:clear()
        end)

        it('should draw title', function ()
          c:render()

          assert.spy(credits.draw_credits_text).was_called(1)
          assert.spy(credits.draw_credits_text).was_called_with(match.ref(c))
        end)

        it('should draw menu', function ()
          c:render()

          assert.spy(menu.draw).was_called(1)
          -- no need to check where exactly it is printed
        end)

      end)

    end)  -- (with menu entered)

  end)  -- (with instance)

end)

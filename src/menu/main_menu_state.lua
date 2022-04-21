-- base class
local gamestate = require("engine/application/gamestate")

local flow = require("engine/application/flow")
local text_helper = require("engine/ui/text_helper")

local menu_item = require("menu/menu_item")
local menu = require("menu/menu_with_sfx")
local visual = require("resources/visual")

-- main menu: gamestate for player navigating in main menu
local main_menu_state = derived_class(gamestate)

main_menu_state.type = ':main_menu'

-- parameters data

-- sequence of menu items to display, with their target states
local menu_item_params = {
  {"start", function(app)
    flow:query_gamestate_type(':ingame')
  end},
}

function main_menu_state:init()
  -- sequence of menu items to display, with their target states
  -- this could be static, but defining in init allows us to avoid
  --  outer scope definition, so we don't need to declare local menu_item
  --  at source top for unity build
  self.items = transform(menu_item_params, unpacking(menu_item))
end

function main_menu_state:on_enter()
  -- create menu and show it with wanted items
  self.menu = menu(self.app --[[, items_count_per_page]], alignments.left, --[[interval_y:]] 3,
    colors.white --[[, prev_page_arrow_offset]], visual.sprite_data_t.menu_cursor, --[[left_cursor_half_width:]] 7)
  self.menu:show_items(self.items)
end

function main_menu_state:on_exit()
  self.menu = nil
end

function main_menu_state:update()
  if self.menu then
    self.menu:update()
  end
end

function main_menu_state:render()
  cls()

  local y = 40
  text_helper.print_centered("where is my belt?", 64, y, colors.white)
  y = y + 10
  -- $version replaced as long as build_single_cartridge.sh passes -v version="$version"
  text_helper.print_centered("V$version", 64, y, colors.white)
  y = y + 20
  text_helper.print_centered("by komehara", 64, y, colors.white)
  y = y + 10
  text_helper.print_centered("komehara.itch.io", 64, y, colors.white)
  y = y + 4 * character_height

  if self.menu then
    self.menu:draw(54, y)
  end
end

return main_menu_state

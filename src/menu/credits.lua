-- base class
local gamestate = require("engine/application/gamestate")

local flow = require("engine/application/flow")
local text_helper = require("engine/ui/text_helper")

local menu_item = require("menu/menu_item")
local menu = require("menu/menu_with_sfx")
local visual = require("resources/visual")

local credits = derived_class(gamestate)

credits.type = ':credits'

-- parameters data

local menu_item_params = {
  {"back", function(app)
    flow:query_gamestate_type(':main_menu')
  end}
}

function credits:init()
  -- sequence of menu items to display, with their target states
  -- this could be static, but defining in init allows us to avoid
  --  outer scope definition, so we don't need to declare local menu_item
  --  at source top for unity build
  self.items = transform(menu_item_params, unpacking(menu_item))
end

function credits:on_enter()
  music(-1)

  self.menu = menu(self.app--[[, 2]], alignments.left, 3, colors.white--[[skip prev_page_arrow_offset]], visual.sprite_data_t.menu_cursor, 7)
  self.menu:show_items(self.items)
end

function credits:on_exit()
end

function credits:update()
  self.menu:update()
end

function credits:render()
  self:draw_credits_text()
  self.menu:draw(screen_width / 2, 121)
end

function credits:draw_credits_text()
  rectfill(0, 0, 127, 127, colors.dark_blue)

  local text_color = colors.white
  local margin_x = 2
  local line_dy = character_height
  local paragraph_margin = 3

  -- top
  local y = 2

  text_helper.print_aligned("where is my belt - credits", 64, y, alignments.horizontal_center, text_color)
  y = y + line_dy + paragraph_margin + 2

  api.print("komehara", margin_x, y, text_color)
  text_helper.print_aligned("programming", 127 - margin_x, y, alignments.right, text_color)
  y = y + line_dy + paragraph_margin
  text_helper.print_aligned("art", 127 - margin_x, y, alignments.right, text_color)
  y = y + line_dy
  text_helper.print_aligned("audio", 127 - margin_x, y, alignments.right, text_color)
  y = y + line_dy + paragraph_margin

  api.print("komehara.itch.io/where-is-my-belt", margin_x, y, text_color)
end

-- export

return credits

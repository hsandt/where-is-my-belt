local gamestate = require("engine/application/gamestate")

-- local flow = require("engine/application/flow")
local text_helper = require("engine/ui/text_helper")

local visual = require("resources/visual")

-- ingame: gamestate for playing either a mission or in infinite mode
local ingame_state = derived_class(gamestate)

ingame_state.type = ':ingame'

function ingame_state:_init()
end

function ingame_state:on_enter()
end

function ingame_state:on_exit()
end

function ingame_state:update()
end

function ingame_state:render()
  cls()

  -- background

  rectfill(0, 0, 127, 63, colors.dark_blue)
  rectfill(0, 64, 127, 127, colors.indigo)

  visual.sprite_data_t.background_lights_half_left:render(vector(63, 77))
  -- draw right part by flipping it
  visual.sprite_data_t.background_lights_half_left:render(vector(65, 77), true)

  -- white board

  -- frame
  local board_margin_x = 18
  local board_left = board_margin_x
  local board_right = 127 - board_margin_x
  local board_top = 8
  local board_bottom = 41
  rectfill(board_left, board_top, board_right, board_bottom, colors.light_gray)

  -- inside
  local board_padding = 2
  local board_inside_left = board_left + board_padding
  local board_inside_right = board_right - board_padding
  local board_inside_top = board_top + board_padding
  local board_inside_bottom = board_bottom - board_padding
  rectfill(board_inside_left, board_inside_top,
     board_inside_right, board_inside_bottom, colors.white)

  -- lines
  local line_margin_x = 6
  local line_left = board_inside_left + line_margin_x
  local line_right = board_inside_right - line_margin_x
  local line_y0 = board_inside_top + 11
  for i=0,2 do
    local line_y = line_y0 + 5 * i
    line(line_left, line_y, line_right, line_y, colors.light_gray)
    -- obstacle start-up indicator
    line(line_right + 2, line_y - 1, line_right + 2, line_y + 1, colors.light_gray)
  end

  -- characters

  local teacher_position = vector(47, 24)
  visual.sprite_data_t.teacher:render(teacher_position)
  visual.sprite_data_t.teacher_arm_level1:render(teacher_position + visual.teacher_arm_attachment_offset)
  visual.sprite_data_t.teacher_pants:render(teacher_position + visual.teacher_pants_attachment_offset)
end

return ingame_state

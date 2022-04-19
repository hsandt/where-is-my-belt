local gamestate = require("engine/application/gamestate")

-- local flow = require("engine/application/flow")
local input = require("engine/input/input")
local text_helper = require("engine/ui/text_helper")

local ingame_numerical_data = require("data/ingame_numerical_data")
local visual = require("resources/visual")

-- ingame: gamestate for playing either a mission or in infinite mode
local ingame_state = derived_class(gamestate)

ingame_state.type = ':ingame'

function ingame_state:init()
  -- state vars
  -- teacher arm level: int between 1 and 3
  self.teacher_arm_level = 1
  -- obstacle positions by level: sequence of 3 sequences of numbers
  --  each embedded sequence contains an arbitrary number of obstacle
  --  relative positions, between:
  --  ingame_numerical_data.obstacle_relative_position_min
  --  (the left-most position on the line)
  --  ingame_numerical_data.obstacle_relative_position_max
  --  (the right-most and first position on the line, excluding obstacle incoming preview)
  --  0 is the teacher chalk x (position where we check for obstacle collision)
  self.obstacle_rel_positions_by_level = {{}, {}, {}}
end

function ingame_state:on_enter()
end

function ingame_state:on_exit()
end

function ingame_state:update()
  if input:is_just_pressed(button_ids.up) then
    self.teacher_arm_level = max(self.teacher_arm_level - 1, 1)
  elseif input:is_just_pressed(button_ids.down) then
    self.teacher_arm_level = min(self.teacher_arm_level + 1, 3)
  end

  for i=1,3 do
    -- dummy random, waiting for proper randomization with minimum interval
    if rnd() < 0.1 then
      add(self.obstacle_rel_positions_by_level[i], ingame_numerical_data.obstacle_relative_position_max)
    end
  end
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
  for i=1,3 do
    local line_y = self:get_line_y(i)
    line(line_left, line_y, line_right, line_y, colors.light_gray)
    -- obstacle start-up indicator
    line(line_right + 2, line_y - 1, line_right + 2, line_y + 1, colors.light_gray)
  end

  -- obstacles
  for i=1,3 do
    local obstacle_rel_positions = self.obstacle_rel_positions_by_level[i]
    for obstacle_rel_pos in all(obstacle_rel_positions) do
      local line_y = self:get_line_y(i)
      line(ingame_numerical_data.obstacle_reference_x + obstacle_rel_pos, line_y - 1,
        ingame_numerical_data.obstacle_reference_x + obstacle_rel_pos, line_y + 1,
        colors.dark_gray)
    end
  end

  -- characters

  local teacher_position = vector(47, 24)
  visual.sprite_data_t.teacher:render(teacher_position)
  visual.teacher_arm_sprites_by_level[self.teacher_arm_level]:render(teacher_position + visual.teacher_arm_attachment_offset)
  visual.sprite_data_t.teacher_pants:render(teacher_position + visual.teacher_pants_attachment_offset)
end

function ingame_state:get_line_y(line_lua_index)
  -- convert lua index to 0-index
  return ingame_numerical_data.obstacle_first_line_y + 6 * (line_lua_index - 1)
end

return ingame_state

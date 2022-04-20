local gamestate = require("engine/application/gamestate")

-- local flow = require("engine/application/flow")
local input = require("engine/input/input")
local text_helper = require("engine/ui/text_helper")

local ingame_numerical_data = require("data/ingame_numerical_data")
local ingame_phase = require("ingame/ingame_phase")
local visual = require("resources/visual")

-- ingame: gamestate for playing either a mission or in infinite mode
local ingame_state = derived_class(gamestate)

ingame_state.type = ':ingame'

function ingame_state:init()
  -- state vars

  -- current phase
  self.phase = ingame_phase.before_play

  -- frames elapsed since entering play phase (only updated in play phase)
  self.frames_since_start_play = 0

  -- teacher arm level: int between 1 and 3
  self.teacher_arm_level = 1

  -- how much pants is falling, from 0 (initial) to 7 (defeat)
  self.teacher_pants_falling_step = 0

  -- obstacle positions by level: sequence of 3 sequences of numbers
  --  each embedded sequence contains an arbitrary number of obstacle
  --  relative positions, between:
  --  ingame_numerical_data.obstacle_relative_position_min
  --  (the left-most position on the line)
  --  ingame_numerical_data.obstacle_relative_position_max
  --  (the right-most and first position on the line, excluding obstacle incoming preview)
  --  0 is the teacher chalk x (position where we check for obstacle collision)
  self.obstacle_rel_positions_by_level = {{}, {}, {}}

  -- sequence of time before next obstacle spawn in frames, indexed by line level
  --  0 is a dummy default, we must randomly generate it on start or we will create
  --  an impassable wall of obstacles
  self.time_before_next_obstacle_spawn_by_level = {0, 0, 0}
end

function ingame_state:on_enter()
  self:start_challenge()
end

function ingame_state:on_exit()
end

function ingame_state:update()
  if self.phase == ingame_phase.play then
    if input:is_just_pressed(button_ids.up) then
      self.teacher_arm_level = max(self.teacher_arm_level - 1, 1)
    elseif input:is_just_pressed(button_ids.down) then
      self.teacher_arm_level = min(self.teacher_arm_level + 1, 3)
    end

    for i=1,3 do
      -- move existing obstacles
      local obstacle_rel_positions = self.obstacle_rel_positions_by_level[i]

      -- iterate backward for safe deletion during loop
      for j=#obstacle_rel_positions,1,-1 do
        obstacle_rel_positions[j] = obstacle_rel_positions[j] - ingame_numerical_data.obstacle_move_speed

        -- check for obstacles that crossed the left limit
        if obstacle_rel_positions[j] < ingame_numerical_data.obstacle_relative_position_min then
          -- remove this obstacle
          deli(obstacle_rel_positions, j)
        else
          -- obstacle in somewhere in the middle, check for collision with teacher arm chalk
          -- check vertical level and horizontal progress
          -- note that visually, fractional positions are floored, so use floor too for collision check
          if self.teacher_arm_level == i and flr(obstacle_rel_positions[j]) == 0 then
            -- on each collision, make pants fall a little more
            self.teacher_pants_falling_step = self.teacher_pants_falling_step + 1
            if self.teacher_pants_falling_step >= 7 then
              -- last falling step reached, player loses this challenge
              self:lose()
            end
          end
        end
      end

      -- count down time to next obstacle if any, but only every [ingame_numerical_data.obstacle_spawn_check_period] frames
      local time_before_next_obstacle_spawn = self.time_before_next_obstacle_spawn_by_level[i]
      if time_before_next_obstacle_spawn > 0 and
          self.frames_since_start_play % ingame_numerical_data.obstacle_spawn_check_period == 0 then
        time_before_next_obstacle_spawn = time_before_next_obstacle_spawn - ingame_numerical_data.obstacle_spawn_check_period
        self.time_before_next_obstacle_spawn_by_level[i] = time_before_next_obstacle_spawn

        -- make sure to check <= 0 in case ingame_numerical_data.obstacle_spawn_check_period > 1
        --  and we go below 0 in one step
        if time_before_next_obstacle_spawn <= 0 then
          -- count down reached 0, spawn obstacle and prepare timer for next one
          self:spawn_obstacle_and_prepare_next_one(i)
        end
      end
    end

    self.frames_since_start_play = self.frames_since_start_play + 1
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

  local base_pants_position = teacher_position + visual.teacher_pants_attachment_offset
  visual.sprite_data_t.teacher_boxer_shorts:render(base_pants_position)

  local pants_position = base_pants_position + vector(0, self.teacher_pants_falling_step)
  visual.teacher_pants_by_falling_step[self.teacher_pants_falling_step]:render(pants_position)

  if self.phase == ingame_phase.failure then
    text_helper.print_aligned("you lost the pants!", screen_width / 2, 91, alignments.center, colors.white, colors.black)
  end
end

-- helpers

function ingame_state:get_line_y(level)
  -- convert level, which is a lua index, to 0-index here
  return ingame_numerical_data.obstacle_first_line_y + 6 * (level - 1)
end

-- play

function ingame_state:start_challenge()
  self.phase = ingame_phase.play

  for i=1,3 do
    self:set_rand_next_obstacle_spawn_time(i)
  end
end

function ingame_state:set_rand_next_obstacle_spawn_time(level)
    self.time_before_next_obstacle_spawn_by_level[level] = self:generate_rand_next_obstacle_spawn_time(level)
end

function ingame_state:generate_rand_next_obstacle_spawn_time(level)
  -- wait for min interval, then spawn next obstacle somewhere between
  --  that time and that time + time range
  -- time range is the number of frames offsets possible, so rnd can be used
  --  with exclusive upper bound indeed
  -- NOTE: for now, level is not used, but it will be useful to detect other
  --  future obstacles incoming and avoid creating an impassable (or very tight)
  --  wall of obstacles
  return ingame_numerical_data.obstacle_min_interval + flr(rnd(ingame_numerical_data.obstacle_spawn_time_range))
end

function ingame_state:spawn_obstacle_and_prepare_next_one(level)
  add(self.obstacle_rel_positions_by_level[level], ingame_numerical_data.obstacle_relative_position_max)
  self:set_rand_next_obstacle_spawn_time(level)
end

-- end of play

function ingame_state:lose()
  -- stop playing so we don't update more collisions
  self.phase = ingame_phase.failure
end

return ingame_state

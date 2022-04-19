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

  -- characters

  local teacher_position = vector(47, 24)
  visual.sprite_data_t.teacher:render(teacher_position)
  visual.sprite_data_t.teacher_arm_level1:render(teacher_position + visual.teacher_arm_attachment_offset)
  visual.sprite_data_t.teacher_pants:render(teacher_position + visual.teacher_pants_attachment_offset)
end

return ingame_state

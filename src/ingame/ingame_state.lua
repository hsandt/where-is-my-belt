local gamestate = require("engine/application/gamestate")

-- local flow = require("engine/application/flow")
local text_helper = require("engine/ui/text_helper")

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

  local title_y = 48
  text_helper.print_centered("ingame", 64, title_y, colors.white)
end

return ingame_state

-- gamestates: ingame
local itest_manager = require("engine/test/itest_manager")
local flow = require("engine/application/flow")

itest_manager:register_itest('start ingame',
    {--[[unused]]}, function ()

  -- enter title menu
  setup_callback(function (app)
    flow:change_gamestate_by_type(':main_menu')
  end)

  -- menu should appear within 2 seconds
  wait(2.0)

  -- player presses o to confirm 'start' (default selection)
  short_press(button_ids.o)

  -- wait a moment to cover 90% of the start cinematic
  wait(20.0)

  -- check that we are still in the ingame state
  final_assert(function ()
    return flow.curr_state.type == ':ingame', "current game state is not ':ingame', has instead type: "..flow.curr_state.type
  end)

end)

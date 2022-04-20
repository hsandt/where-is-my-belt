-- gamestates: ingame
local itest_manager = require("engine/test/itest_manager")
local flow = require("engine/application/flow")

itest_manager:register_itest('enter ingame',
    {--[[unused]]}, function ()

  -- enter main menu
  setup_callback(function (app)
    flow:change_gamestate_by_type(':main_menu')
  end)

  -- menu should appear within 2 seconds
  wait(2.0)

  -- player presses o to confirm 'start' (default selection)
  short_press(button_ids.o)

  -- wait a short moment
  wait(0.5)

  -- check that we are now in the ingame state
  final_assert(function ()
    return flow.curr_state.type == ':ingame', "current game state is not ':ingame', has instead type: "..flow.curr_state.type
  end)

end)

itest_manager:register_itest('#solo play ingame',
    {--[[unused]]}, function ()

  -- enter main menu
  setup_callback(function (app)
    flow:change_gamestate_by_type(':ingame')
  end)

  -- wait without doing anything to catch obvious errors
  wait(10.0)

  -- check that we are still in the ingame state
  final_assert(function ()
    return flow.curr_state.type == ':ingame', "current game state is not ':ingame', has instead type: "..flow.curr_state.type
  end)

end)

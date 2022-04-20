-- make sure to add this file to game_constant_module_paths_string in build_single_cartridge.sh

--#if game_constants

local ingame_numerical_data = {
  obstacle_first_line_y = 21,  -- in pixels
  obstacle_reference_x = 69,   -- in pixels
  obstacle_relative_position_min = -43,  -- in pixels
  obstacle_relative_position_max = 32,   -- in pixels
  obstacle_min_interval = 10,      -- in frames
  obstacle_spawn_time_range = 20,  -- in frames
}

--(game_constants)
--#endif

return ingame_numerical_data

-- make sure to add this file to game_constant_module_paths_string in build_single_cartridge.sh

--#if game_constants

local ingame_numerical_data = {
  obstacle_first_line_y = 21,  -- in pixels
  obstacle_reference_x = 69,   -- in pixels
  obstacle_relative_position_min = -43,  -- in pixels
  obstacle_relative_position_max = 32,   -- in pixels
  obstacle_base_min_interval = 40,      -- in frames
  obstacle_min_interval_decrease_per_second = 0.75,      -- in frames/second
  obstacle_min_min_interval = 20,      -- in frames
  obstacle_base_spawn_time_range = 40,  -- in frames
  obstacle_spawn_time_range_decrease_per_second = 0.75,  -- in frames/second
  obstacle_min_spawn_time_range = 20,  -- in frames
  obstacle_move_speed = 0.5,  -- in px/frames
  -- we countdown obstacle spawn time left every [obstacle_spawn_check_period] frames
  --  this is only useful to avoid jittering when obstacle_move_speed is fractional
  --  by syncing obstacle spawn time to the smallest factor of it that gives a integer
  --  (e.g. if obstacle_move_speed is 0.5, we recommend obstacle_spawn_check_period = 2)
  -- this may not work with all obstacle_move_speed values (e.g. 0.3 requires x10 to reach integer 3,
  --  but updating every 10 frames is not reactive enough)
  -- set to 1 for update every frame (ignore jittering)
  obstacle_spawn_check_period = 2, -- in frames
  pants_base_fall_speed = 0.5,  -- per second
  pants_fall_speed_increase_per_pull = 0.25,
  pants_max_fall_speed = 2,     -- per second
  delay_before_pants_fall = 60,  -- in frames
  suspicion_increase_on_pull_pants = 3,
  suspicion_increase_on_hit_obstacle = 1,
  suspicion_cooldown_per_second = 1,
  delay_before_suspicion_cooldown = 30,  -- in frames
}

--(game_constants)
--#endif

return ingame_numerical_data

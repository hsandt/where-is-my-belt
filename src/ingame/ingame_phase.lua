-- make sure to add this file to game_constant_module_paths_string in build_single_cartridge.sh

--#if game_constants

local ingame_phase = {
  before_play = 0,
  play = 1,
  success = 2,
  failure = 3,
}

--(game_constants)
--#endif

return ingame_phase

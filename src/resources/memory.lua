-- make sure to add this file to game_constant_module_paths_string in build_single_cartridge.sh

--#if game_constants

local memory = {
  -- add address offset of persistent memory (dset/dget) here
  high_score = 0
}

--(game_constants)
--#endif

return memory

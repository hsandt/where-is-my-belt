-- make sure to add this file to game_constant_module_paths_string in build_single_cartridge.sh

--#if game_constants

-- audio usage ranges
-- use 8-31 for music tracks
-- use 32-63 for sound effects

local audio = {}

audio.sfx_ids = {

  menu_select = 50,
  menu_confirm = 51,
  menu_swipe = 52,
}

audio.jingle_ids = {
  success = 0,
  failure = 0,
}

audio.music_ids = {
  ingame = 0,
}

--(game_constants)
--#endif

return audio

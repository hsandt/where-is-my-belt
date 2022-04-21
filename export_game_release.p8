pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- Run this commandline script with:
-- $ pico8 -x export_cartridge.p8

-- It will export .bin and .p8.png for the current game release
-- Make sure to ./build_game release && ./install_cartridges.sh first
-- Note that it will not warn if cartridge is not found.
-- Paths are relative to PICO-8 carts directory.

-- #title
local title = "where-is-my-belt"
-- #version
-- PICO-8 cannot read data/version.txt, so exceptionally set the version manually here
local version = "0.1"
-- #cartridge
local entry_cartridge_name = "core"
local template_file = "where-is-my-belt_template"  -- no .html extension
local export_folder = title.."/v"..version.."_release"
local game_basename = title.."_v"..version.."_release"
local rel_png_folder = game_basename.."_png_cartridges"

-- #cartridge (tagged to easily find what code to change when adding a new cartridge,
-- and because this script cannot access external files like cartridges.txt)
local additional_main_cartridges_list = {
  -- insert additional (non-entry) main cartridges here
}

-- #data
local data_cartridges_list = {
  -- insert standalone data cartridges here
  -- remember that built-in data cartridges are built together with the corresponding
  --  main cartridge code, and don't need to be added here
}

-- #icon
-- custom icon is stored in builtin_data_{entry_cartridge}.p8:
--  as a 16x16 square                      => -s 2 tiles wide
--  with top-left cell at sprite 46 (run1) => -i 46
--  on pink (color 14) background          => -c 14
-- and most importantly we pass additional logic and data files as additional cartridges
local icon_tile_size = 2
local icon_top_left_sprite_id = 46
local icon_transparent_color = 14

cd(export_folder)

  local entry_cartridge = title.."_"..entry_cartridge_name..".p8"

  -- all main cartridges, including entry cartridge
  local main_cartridges_list = {entry_cartridge}
  for additional_main_cartridge in all(additional_main_cartridges_list) do
    add(main_cartridges_list, additional_main_cartridge)
  end

  -- PNG

  -- prepare folder for png cartridges
  mkdir(rel_png_folder)

  -- data do not contain any code, so no need to adapt reload ".p8" -> ".p8.png"
  -- so just save them directly as png
  for cartridge_name in all(data_cartridges_list) do
    local success = load(cartridge_name)
    if success then
      save(rel_png_folder.."/"..cartridge_name..".png")
    else
      printh("ERROR: loading data cartridge '"..cartridge_name.."' failed, could not save as .png")
    end
  end

  -- main cartridges need to be *adapted for PNG* for reload, so load those adapted versions
  --  to resave them as PNG
  -- (export_and_patch_cartridge_release.sh must have called pico-boots/scripts/adapt_for_png.py)
  -- the metadata label is used automatically for each
  cd("p8_for_png")

    for cartridge_name in all(main_cartridges_list) do
      local success = load(cartridge_name)
      if success then
        -- save as png (make sure to go one level up first since we are one level down)
        save("../"..rel_png_folder.."/"..cartridge_name..".png")
      else
        printh("ERROR: loading main cartridge '"..cartridge_name.."' failed, could not save as .png")
      end
    end

  cd("..")

  printh("Resaved (adapted) cartridges as PNG in carts/"..export_folder.."/"..rel_png_folder)


  -- BIN & WEB

  -- load the original (not adapted for PNG) entry cartridge (titlemenu)
  -- this will serve as main entry point for the whole game
  local success = load(entry_cartridge)
  if success then

    -- concatenate cartridge names with space separator with a very simplified version
    --  of string.lua > joinstr_table that doesn't mind about adding an initial space
    local additional_cartridges_string = ""
    for cartridge_name in all(additional_main_cartridges_list) do
      additional_cartridges_string = additional_cartridges_string.." "..cartridge_name
    end
    for cartridge_name in all(data_cartridges_list) do
      additional_cartridges_string = additional_cartridges_string.." "..cartridge_name
    end


    -- BIN

    -- exports are done via EXPORT, and can use a custom icon stored in builtin_data_{entry_cartridge}.p8,
    --  instead of the .p8.png label, based on game-specific parameters defined at the top
    export(game_basename..".bin "..additional_cartridges_string.." -i "..icon_top_left_sprite_id.." -s "..
      icon_tile_size.." -c "..icon_transparent_color)
    printh("Exported binaries in carts/"..export_folder.."/"..game_basename..".bin")


    -- WEB

    mkdir(game_basename.."_web")
    -- Do not cd into game_basename.."_web" because we want the additional cartridges to be accessible
    --  in current path. Instead, export directly into the _web folder
    -- Use custom template. It is located in plates/{template_file}.html and copied into PICO-8 config dir plates
    --  in export_and_patch_cartridge_release.sh
    export(game_basename.."_web/"..game_basename..".html "..additional_cartridges_string.." -i "..
      icon_top_left_sprite_id.." -s "..icon_tile_size.." -c "..icon_transparent_color.." -p "..template_file)
    printh("Exported HTML in carts/"..export_folder.."/"..game_basename..".html")

  else
    printh("ERROR: loading entry cartridge '"..entry_cartridge.."' failed, could not export .bin nor web")
  end

cd("..")

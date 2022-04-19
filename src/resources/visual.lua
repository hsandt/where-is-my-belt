local animated_sprite_data = require("engine/render/animated_sprite_data")
local sprite_data = require("engine/render/sprite_data")

local visual = {
  dummy_colors = {0}
}

local sprite_data_t = transform(
  {
    -- sprite_data(id_loc: sprite_id_location([1], [2]), span: tile_vector([3], [4]), pivot: vector([5], [6]), transparent_color_arg: [7]),
    -- parameters:                        {id_loc(2), span(2), pivot(2), transparent_color_arg(1)}

    -- STATIC SPRITES
    --#if mouse
    cursor                              = {     9, 0,    1, 1,    0, 0,               colors.pink},
    --#endif
    menu_cursor                         = {    10, 0,    1, 1,    4, 4,               colors.green},
    teacher                             = {     0, 1,    3, 7,    0, 0,               colors.pink},
    teacher_arm_level1                  = {     3, 1,    2, 3,    0,17,               colors.pink},
    teacher_arm_level2                  = {     5, 2,    2, 2,    0, 9,               colors.pink},
    teacher_arm_level3                  = {     7, 2,    2, 2,    0, 9,               colors.pink},
    teacher_pants                       = {     3, 5,    2, 2,    1, 0,               colors.pink},
    background_lights_half_left         = {     0,10,    7, 6,   52, 3,               colors.pink},

    -- ANIMATION SPRITES
    -- teacher_arms                        = {     1, 0,    2, 3,    0,  0,              colors.pink},
  },
  function (params)
    return sprite_data(sprite_id_location(params[1], params[2]), tile_vector(params[3], params[4]), vector(params[5], params[6]), params[7])
  end
)

visual.sprite_data_t = sprite_data_t

-- extra information
visual.teacher_arm_attachment_offset = vector(14, 13)
visual.teacher_pants_attachment_offset = vector(5, 29)

-- convenient access
visual.teacher_arm_sprites_by_level = {
  sprite_data_t.teacher_arm_level1,
  sprite_data_t.teacher_arm_level2,
  sprite_data_t.teacher_arm_level3,
}

-- ANIMATIONS
visual.animated_sprite_data_t = {
  -- manual construction via sprite direct access appears longer than animated_sprite_data.create in code,
  --  but this will actually be minified and therefore very compact (as names are not protected)
  -- note we now pass data directly without ["once"], as fx will create its own ["once"]
  dummy_anim1 = animated_sprite_data(
    {
      sprite_data_t.menu_cursor,
      sprite_data_t.menu_cursor,
    },
    5,
    anim_loop_modes.freeze_last
  ),
}

return visual

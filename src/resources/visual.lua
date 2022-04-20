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
    -- suspicion_eye added for reference, but due to the need to fill it with sspr in red,
    --  we won't be using tile-wide data but rather pixel-precise blitting
    -- we do use the outline, however
    -- suspicion_eye_fill                  = {    11, 0,    2, 2,    6, 5,               colors.pink},
    suspicion_eye_outline               = {    13, 0,    3, 2,    9, 6,               colors.pink},
    teacher                             = {     0, 1,    3, 7,    0, 0,               colors.pink},
    teacher_arm_level1                  = {     3, 1,    2, 3,    0,17,               colors.pink},
    teacher_arm_level2                  = {     5, 2,    2, 2,    0, 9,               colors.pink},
    teacher_arm_level3                  = {     7, 2,    2, 2,    0, 9,               colors.pink},
    teacher_boxer_shorts                = {     3, 4,    2, 1,    0, 0,               colors.green},
    teacher_pants0                      = {     0, 8,    2, 2,    2, 0,               colors.pink},
    teacher_pants1                      = {     2, 8,    2, 2,    2, 0,               colors.pink},
    teacher_pants2                      = {     4, 8,    2, 2,    2, 0,               colors.pink},
    teacher_pants3                      = {     6, 8,    2, 2,    2, 0,               colors.pink},
    teacher_pants4                      = {     8, 8,    2, 2,    2, 0,               colors.pink},
    teacher_pants5                      = {    10, 8,    2, 2,    2, 0,               colors.pink},
    teacher_pants6                      = {    12, 8,    2, 2,    2, 0,               colors.pink},
    teacher_pants7                      = {    14, 8,    2, 2,    2, 0,               colors.pink},
    background_lights_half_left         = {     0,10,    7, 6,   52, 3,               colors.pink},
    pupil_left                          = {     7,11,    3, 5,    0,39,               colors.pink},
    desk_left                           = {    10,10,    5, 4,    0,31,               colors.pink},
    desk_right_light                    = {    15,10,    1, 2,    0, 0,               colors.pink},
    chair_left                          = {    10,14,    3, 2,    0,15,               colors.pink},

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
visual.teacher_pants_by_falling_step = {
  [0] = sprite_data_t.teacher_pants0,
  sprite_data_t.teacher_pants1,
  sprite_data_t.teacher_pants2,
  sprite_data_t.teacher_pants3,
  sprite_data_t.teacher_pants4,
  sprite_data_t.teacher_pants5,
  sprite_data_t.teacher_pants6,
  sprite_data_t.teacher_pants7,
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

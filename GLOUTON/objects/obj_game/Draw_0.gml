draw_set_color(make_color_rgb(18, 16, 24));
draw_rectangle(-20000, -20000, GAME_W + 20000, GAME_H + 20000, false);
draw_set_color(c_white);

var sheet = asset_get_index("spr_tiles");
if (sheet >= 0) {
    if (!surface_exists(floor_surface)) {
        floor_surface = surface_create(GAME_W, GAME_H);
        surface_set_target(floor_surface);
        draw_clear(make_color_rgb(34, 32, 44));
        for (var row = 0; row < floor_rows; row++) {
            for (var col = 0; col < floor_columns; col++) {
                var is_wall = (col < WALL_THICK || col >= floor_columns - WALL_THICK || row < WALL_THICK || row >= floor_rows - WALL_THICK);
                var tile_index = is_wall ? WALL_TILE : floor_tiles[row * floor_columns + col];
                draw_sprite_part(sheet, 0, (tile_index mod 12) * 16, (tile_index div 12) * 16, 16, 16, col * 16, row * 16);
            }
        }
        for (var index = 0; index < array_length(floor_specks); index++) {
            var speck = floor_specks[index];
            draw_set_alpha(0.12);
            draw_set_color(speck.dark ? c_black : c_white);
            draw_circle(speck.px, speck.py, speck.radius, false);
        }
        draw_set_alpha(1);
        draw_set_color(c_white);
        surface_reset_target();
    }
    draw_surface(floor_surface, 0, 0);
} else {
    draw_set_color(make_color_rgb(28, 30, 40));
    draw_rectangle(0, 0, GAME_W, GAME_H, false);
}

draw_set_color(make_color_rgb(120, 90, 60));
draw_rectangle(0, 0, GAME_W, GAME_H, true);
draw_set_color(c_white);

game_set_speed(60, gamespeed_fps);
gpu_set_tex_filter(false);
randomize();

depth = 90;

global.dead = false;
global.won = false;
global.started = false;

view_enabled = true;
view_visible[0] = true;
view_wport[0] = VIEW_W;
view_hport[0] = VIEW_H;
game_camera = camera_create_view(0, 0, VIEW_W, VIEW_H, 0, noone, -1, -1, -1, -1);
view_set_camera(0, game_camera);

zoom = 1;
shake = 0;
spawn_timer = SPAWN_EVERY;
elapsed = 0;
end_sound_played = false;
last_display_width = -1;
last_display_height = -1;

wave = 1;
wave_timer = WAVE_TIME;
banner_timer = 0;
banner_text = "";
boss_spawned = false;
boss = noone;

floor_surface = -1;
floor_columns = GAME_W div 16;
floor_rows = GAME_H div 16;
floor_tiles = array_create(floor_columns * floor_rows, 48);
for (var index = 0; index < floor_columns * floor_rows; index++) {
    floor_tiles[index] = (random(1) < 0.82) ? 48 : choose(49, 50, 51, 52, 53);
}
floor_specks = [];
repeat (1200) {
    array_push(floor_specks, {
        px: random(GAME_W),
        py: random(GAME_H),
        radius: random_range(1, 2.4),
        dark: (random(1) < 0.5)
    });
}

global.player = instance_create_depth(GAME_W * 0.5, GAME_H * 0.5, 0, obj_player);
repeat (START_PREY) spawn_food();

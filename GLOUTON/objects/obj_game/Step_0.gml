var display_width = (os_browser == browser_not_a_browser) ? window_get_width() : browser_width;
var display_height = (os_browser == browser_not_a_browser) ? window_get_height() : browser_height;

if (display_width > 0 && display_height > 0 && (display_width != last_display_width || display_height != last_display_height)) {
    last_display_width = display_width;
    last_display_height = display_height;
    view_wport[0] = display_width;
    view_hport[0] = display_height;
    window_set_size(display_width, display_height);
    surface_resize(application_surface, display_width, display_height);
    display_set_gui_size(display_width, display_height);
}

if (banner_timer > 0) banner_timer -= 1;

if (!global.started) {
    if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left)) {
        global.started = true;
    }
}

if (global.started && !global.dead && !global.won) {
    elapsed += 1;

    if (!boss_spawned) {
        wave_timer -= 1;
        if (wave_timer <= 0) {
            wave += 1;
            wave_timer = WAVE_TIME;
            banner_text = "WAVE " + string(wave);
            banner_timer = 100;
            play_sound("snd_ui");
        }

        var difficulty = clamp((wave - 1) / (WAVE_MAX - 1), 0, 1);
        var spawn_interval = round(lerp(45, 14, difficulty));
        var prey_limit = round(lerp(38, 72, difficulty));

        spawn_timer -= 1;
        if (spawn_timer <= 0 && instance_number(obj_prey) < prey_limit) {
            spawn_timer = spawn_interval;
            var threat_chance = lerp(THREAT_CHANCE_MIN, THREAT_CHANCE_MAX, difficulty);
            if (instance_exists(global.player) && random(1) < threat_chance) {
                var player_size = global.player.size;
                var threat_radius = clamp(player_size * random_range(1.05, 1.4), player_size * 1.05, 130);
                spawn_threat(threat_radius);
            } else {
                spawn_food();
            }
        }

        if (instance_exists(global.player) && global.player.size >= BOSS_TRIGGER) {
            boss_spawned = true;
            boss = spawn_boss();
            banner_text = "THE SORCERER";
            banner_timer = 150;
            play_sound("snd_win");
        }
    }
}

if ((global.won || global.dead) && !end_sound_played) {
    play_sound(global.won ? "snd_win" : "snd_lose");
    end_sound_played = true;
}

if ((global.dead || global.won) && keyboard_check_pressed(ord("R"))) {
    play_sound("snd_ui");
    if (surface_exists(floor_surface)) surface_free(floor_surface);
    room_restart();
}

if (instance_exists(global.player)) {
    var player = global.player;
    var target_zoom = clamp(1 + (player.size - START_SIZE) / ZOOM_DIV, 1, ZOOM_MAX);
    zoom = lerp(zoom, target_zoom, 0.06);
    var view_aspect = view_wport[0] / max(1, view_hport[0]);
    var view_height = VIEW_H * zoom;
    var view_width = view_height * view_aspect;
    shake = max(0, shake - 0.5);
    var shake_x = (shake > 0) ? random_range(-shake, shake) : 0;
    var shake_y = (shake > 0) ? random_range(-shake, shake) : 0;
    camera_set_view_size(game_camera, view_width, view_height);
    camera_set_view_pos(game_camera, player.x - view_width * 0.5 + shake_x, player.y - view_height * 0.5 + shake_y);
}


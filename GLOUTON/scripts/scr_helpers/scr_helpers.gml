function size_from_mass(mass_value) {
    return SIZE_K * sqrt(mass_value);
}

function mass_from_size(radius) {
    var ratio = radius / SIZE_K;
    return ratio * ratio;
}

function approach(current, target, step) {
    if (current < target) return min(current + step, target);
    return max(current - step, target);
}

function draw_td_tile(tile_index, draw_x, draw_y, scale) {
    static sheet = asset_get_index("spr_tiles");
    if (sheet < 0) return false;
    var tile_left = (tile_index mod 12) * 16;
    var tile_top  = (tile_index div 12) * 16;
    draw_sprite_part_ext(sheet, 0, tile_left, tile_top, 16, 16, draw_x - 8 * scale, draw_y - 8 * scale, scale, scale, c_white, 1);
    return true;
}

function choose_prey_type() {
    static types = build_prey_types();
    var total_weight = 0;
    for (var i = 0; i < array_length(types); i++) total_weight += types[i].weight;
    var pick = random(total_weight);
    for (var i = 0; i < array_length(types); i++) {
        pick -= types[i].weight;
        if (pick <= 0) return types[i];
    }
    return types[0];
}

function spawn_at(tile_index, prey_colour, prey_trait, radius, move_speed) {
    var spawn_x, spawn_y, attempts = 0;
    do {
        spawn_x = random_range(60, GAME_W - 60);
        spawn_y = random_range(60, GAME_H - 60);
        attempts++;
    } until (!instance_exists(global.player)
          || point_distance(spawn_x, spawn_y, global.player.x, global.player.y) > 300
          || attempts > 12);

    var prey = instance_create_depth(spawn_x, spawn_y, 0, obj_prey);
    prey.size  = radius;
    prey.col   = prey_colour;
    prey.trait = prey_trait;
    prey.tile  = tile_index;
    prey.spd   = move_speed;
    prey.mass  = mass_from_size(radius);
    return prey;
}

function spawn_food_natural() {
    var type = choose_prey_type();
    return spawn_at(type.tile, type.col, type.trait, type.radius, random_range(0.6, 1.4));
}

function spawn_morsel(radius) {
    return spawn_at(108, make_color_rgb(90, 200, 140), "none", radius, random_range(0.6, 1.2));
}

function spawn_threat(radius) {
    var tile_index, threat_colour;
    if (radius < 40) {
        tile_index = 86;
        threat_colour = make_color_rgb(210, 210, 200);
    } else if (radius < 70) {
        tile_index = 96;
        threat_colour = make_color_rgb(170, 185, 210);
    } else {
        tile_index = 85;
        threat_colour = make_color_rgb(170, 110, 80);
    }
    return spawn_at(tile_index, threat_colour, "none", radius, random_range(1.0, 1.6));
}

function spawn_food() {
    if (instance_exists(global.player) && random(1) < 0.5) {
        var radius = clamp(global.player.size * random_range(0.45, 0.85), 8, 120);
        return spawn_morsel(radius);
    }
    return spawn_food_natural();
}

function spawn_boss() {
    var spawn_x = GAME_W * 0.5;
    var spawn_y = GAME_H * 0.5;
    if (instance_exists(global.player)) {
        spawn_x = clamp(GAME_W - global.player.x, 120, GAME_W - 120);
        spawn_y = clamp(GAME_H - global.player.y, 120, GAME_H - 120);
    }
    var boss = instance_create_depth(spawn_x, spawn_y, 0, obj_prey);
    boss.is_boss      = true;
    boss.size         = BOSS_RADIUS;
    boss.tile         = 84;
    boss.col          = make_color_rgb(170, 90, 200);
    boss.trait        = "none";
    boss.hp_max       = BOSS_HP;
    boss.hp           = BOSS_HP;
    boss.mass         = mass_from_size(BOSS_RADIUS);
    boss.orb_t        = 30;
    boss.charge_t     = CHARGE_INTERVAL;
    boss.charge_state = 0;
    boss.bite_cd      = 0;
    return boss;
}

function spawn_weakpoints(boss, count) {
    with (boss) {
        for (var i = 0; i < count; i++) {
            var burst_dir = random(360);
            var orb = instance_create_depth(x, y, -50, obj_prey);
            orb.is_weakpoint = true;
            orb.wp_boss      = id;
            orb.size         = WP_SIZE;
            orb.mass         = mass_from_size(WP_SIZE);
            orb.tile         = -1;
            orb.trait        = "none";
            orb.life         = ORB_LIFE;
            orb.vx           = lengthdir_x(random_range(4, 8), burst_dir);
            orb.vy           = lengthdir_y(random_range(4, 8), burst_dir);
        }
    }
}

function boss_damage(boss, amount) {
    var boss_died = false;
    with (boss) {
        hp -= amount;
        hit_flash = 1;
        if (hp <= 0) {
            for (var i = 0; i < 26; i++) {
                make_fx(x + random_range(-size, size), y + random_range(-size, size), make_color_rgb(255, 220, 120), 22);
            }
            boss_died = true;
            instance_destroy();
        }
    }
    if (boss_died) {
        global.won = true;
        with (obj_game) shake = max(shake, 26);
    } else {
        with (obj_game) shake = max(shake, 4);
    }
}

function make_fx(fx_x, fx_y, fx_colour, start_radius) {
    var effect = instance_create_depth(fx_x, fx_y, -100000, obj_fx);
    effect.col = fx_colour;
    effect.start_radius = start_radius;
    return effect;
}

function play_sound(sound_name) {
    var sound = asset_get_index(sound_name);
    if (sound >= 0 && audio_exists(sound)) audio_play_sound(sound, 10, false);
}

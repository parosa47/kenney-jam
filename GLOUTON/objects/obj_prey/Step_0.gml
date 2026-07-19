if (global.dead || global.won) exit;

if (is_weakpoint) {
    x += vx;
    y += vy;
    vx *= 0.90;
    vy *= 0.90;
    if (x < WALL_INSET + size || x > GAME_W - WALL_INSET - size) vx = -vx;
    if (y < WALL_INSET + size || y > GAME_H - WALL_INSET - size) vy = -vy;
    x = clamp(x, WALL_INSET + size, GAME_W - WALL_INSET - size);
    y = clamp(y, WALL_INSET + size, GAME_H - WALL_INSET - size);
    life -= 1;
    if (life <= 0) instance_destroy();
    wobble += 0.3;
    depth = -y;
    exit;
}

if (is_boss) {
    boss_phase = (hp < hp_max * 0.34) ? 2 : ((hp < hp_max * 0.67) ? 1 : 0);
    if (bite_cd > 0) bite_cd -= 1;

    var boss_afraid = instance_exists(global.player) && global.player.empowered_t > 0;

    if (boss_afraid) {
        charge_state = 0;
        if (instance_exists(global.player)) {
            dir = point_direction(global.player.x, global.player.y, x, y);
            var flee_speed = BOSS_CHASE + 0.7 + boss_phase * 0.3;
            x += lengthdir_x(flee_speed, dir);
            y += lengthdir_y(flee_speed, dir);
        }
    } else if (charge_state == 2) {
        x += lengthdir_x(CHARGE_SPEED, charge_dir);
        y += lengthdir_y(CHARGE_SPEED, charge_dir);
        charge_time -= 1;
        if (charge_time <= 0) charge_state = 0;
    } else if (charge_state == 1) {
        charge_time -= 1;
        if (charge_time <= 0) {
            charge_state = 2;
            charge_time = CHARGE_DURATION;
            if (instance_exists(global.player)) charge_dir = point_direction(x, y, global.player.x, global.player.y);
        }
    } else if (instance_exists(global.player)) {
        dir = point_direction(x, y, global.player.x, global.player.y);
        var chase_speed = BOSS_CHASE + boss_phase * 0.35;
        x += lengthdir_x(chase_speed, dir);
        y += lengthdir_y(chase_speed, dir);
    }
    x = clamp(x, WALL_INSET + size, GAME_W - WALL_INSET - size);
    y = clamp(y, WALL_INSET + size, GAME_H - WALL_INSET - size);

    orb_t -= 1;
    if (orb_t <= 0) {
        orb_t = ORB_INTERVAL;
        spawn_weakpoints(id, WP_COUNT);
    }

    if (!boss_afraid && charge_state == 0) {
        charge_t -= 1;
        if (charge_t <= 0) {
            charge_t = CHARGE_INTERVAL - boss_phase * 45;
            charge_state = 1;
            charge_time = CHARGE_TELEGRAPH;
        }
    }

    if (hit_flash > 0) hit_flash -= 0.08;
    wobble += 0.15;
    depth = -y;
    exit;
}

var ai_mode = 0;
var player = global.player;
if (instance_exists(player)) {
    var player_distance = point_distance(x, y, player.x, player.y);
    if (player.size > size * EAT_MARGIN && player_distance < 320) {
        dir = point_direction(player.x, player.y, x, y);
        ai_mode = 1;
    } else if (size > player.size * HURT_MARGIN && player_distance < 360) {
        dir = point_direction(x, y, player.x, player.y);
        ai_mode = -1;
    }
}

if (ai_mode == 0) {
    turn_timer -= 1;
    if (turn_timer <= 0) {
        dir += random_range(-50, 50);
        turn_timer = irandom_range(30, 90);
    }
}

var current_speed = spd * (ai_mode == 1 ? 1.8 : (ai_mode == -1 ? 1.1 : 1));
x += lengthdir_x(current_speed, dir);
y += lengthdir_y(current_speed, dir);

if (x < WALL_INSET + size)          { x = WALL_INSET + size;          dir = 180 - dir; }
if (x > GAME_W - WALL_INSET - size) { x = GAME_W - WALL_INSET - size; dir = 180 - dir; }
if (y < WALL_INSET + size)          { y = WALL_INSET + size;          dir = -dir; }
if (y > GAME_H - WALL_INSET - size) { y = GAME_H - WALL_INSET - size; dir = -dir; }

wobble += 0.2;
depth = -y;

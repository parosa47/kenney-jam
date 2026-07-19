if (global.dead || global.won || !global.started) {
    squash_x = approach(squash_x, 1, 0.05);
    squash_y = approach(squash_y, 1, 0.05);
    flash = approach(flash, 0, 0.06);
    wobble += 0.05;
    exit;
}

if (hit_cooldown > 0) hit_cooldown -= 1;
if (dash_cooldown > 0) dash_cooldown -= 1;
if (fire_cooldown > 0) fire_cooldown -= 1;
if (dash_time > 0) dash_time -= 1;
if (fire_time > 0) fire_time -= 1;
if (speed_cooldown > 0) speed_cooldown -= 1;
if (speed_time > 0) speed_time -= 1;
if (empowered_t > 0) empowered_t -= 1;
flash = approach(flash, 0, 0.06);
squash_x = approach(squash_x, 1, 0.05);
squash_y = approach(squash_y, 1, 0.05);

if (keyboard_check_pressed(ord("1"))) active_slot = 0;
if (keyboard_check_pressed(ord("2"))) active_slot = 1;
if (keyboard_check_pressed(ord("3"))) active_slot = 2;
active_slot = clamp(active_slot, 0, max(0, array_length(traits) - 1));

var press_right = keyboard_check(ord("D")) || keyboard_check(vk_right);
var press_left  = keyboard_check(ord("Q")) || keyboard_check(ord("A")) || keyboard_check(vk_left);
var press_up    = keyboard_check(ord("Z")) || keyboard_check(ord("W")) || keyboard_check(vk_up);
var press_down  = keyboard_check(ord("S")) || keyboard_check(vk_down);
var input_x = press_right - press_left;
var input_y = press_down - press_up;
if (input_x != 0 && input_y != 0) {
    input_x *= 0.70711;
    input_y *= 0.70711;
}
moving = (input_x != 0 || input_y != 0);
if (moving) face_dir = point_direction(0, 0, input_x, input_y);

var growth = clamp((size - START_SIZE) / (WIN_SIZE - START_SIZE), 0, 1);
var move_speed = lerp(SPEED_SMALL, SPEED_BIG, growth);
if (speed_time > 0) move_speed *= SPEED_TRAIT_MULT;

if (dash_time > 0) {
    x += lengthdir_x(DASH_SPEED, dash_dir);
    y += lengthdir_y(DASH_SPEED, dash_dir);
} else {
    x += input_x * move_speed;
    y += input_y * move_speed;
}

var wall_limit = WALL_INSET + size;
x = clamp(x, wall_limit, GAME_W - wall_limit);
y = clamp(y, wall_limit, GAME_H - wall_limit);

wobble += moving ? 0.35 : 0.12;

if (fire_time > 0) {
    with (obj_prey) {
        if (point_distance(x, y, other.x, other.y) < other.size + FIRE_RADIUS) {
            if (is_boss) {
                boss_damage(id, FIRE_DAMAGE);
            } else if (is_weakpoint) {
                other.empowered_t = EMPOWER_TIME;
                other.absorb(mass, trait, x, y, col);
                instance_destroy();
            } else if (size < other.size * 1.6) {
                other.absorb(mass, trait, x, y, col);
                instance_destroy();
            }
        }
    }
}

with (obj_prey) {
    if (point_distance(x, y, other.x, other.y) < other.size + size - 4) {
        if (is_boss) {
            if (other.empowered_t > 0) {
                if (bite_cd <= 0) {
                    bite_cd = BITE_CD;
                    play_sound("snd_eat");
                    var knockback_dir = point_direction(other.x, other.y, x, y);
                    x += lengthdir_x(70, knockback_dir);
                    y += lengthdir_y(70, knockback_dir);
                    x = clamp(x, WALL_INSET + size, GAME_W - WALL_INSET - size);
                    y = clamp(y, WALL_INSET + size, GAME_H - WALL_INSET - size);
                    boss_damage(id, BITE_DAMAGE);
                }
            } else if (other.hit_cooldown <= 0) {
                with (other) {
                    mass = max(MASS_MIN, mass * 0.82);
                    size = size_from_mass(mass);
                    hit_cooldown = 55;
                    flash = 1;
                    squash_x = 0.8;
                    squash_y = 1.25;
                    play_sound("snd_hurt");
                    if (mass <= MASS_MIN + 0.5) global.dead = true;
                }
                var push_dir = point_direction(x, y, other.x, other.y);
                other.x += lengthdir_x(90, push_dir);
                other.y += lengthdir_y(90, push_dir);
                with (obj_game) shake = max(shake, 12);
            }
        } else if (other.size > size * EAT_MARGIN) {
            if (is_weakpoint) other.empowered_t = EMPOWER_TIME;
            other.absorb(mass, trait, x, y, col);
            instance_destroy();
        } else if (size > other.size * HURT_MARGIN) {
            other.take_hit(mass);
        }
    }
}

if (keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left)) use_trait();

depth = -y;

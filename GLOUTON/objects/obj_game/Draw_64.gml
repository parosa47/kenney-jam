draw_set_font(-1);
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var padding = 16;

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

if (instance_exists(global.player)) {
    var player = global.player;
    draw_text(padding, padding,      "Size: "  + string(round(player.size)));
    draw_text(padding, padding + 22, "Score: " + string(player.game_score));

    if (!boss_spawned) {
        var progress = clamp((player.size - START_SIZE) / (BOSS_TRIGGER - START_SIZE), 0, 1);
        var bar_width = 240, bar_height = 14, bar_x = padding, bar_y = padding + 48;
        draw_set_color(make_color_rgb(50, 54, 70));
        draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);
        draw_set_color(make_color_rgb(90, 220, 160));
        draw_rectangle(bar_x, bar_y, bar_x + bar_width * progress, bar_y + bar_height, false);
        draw_set_color(c_white);
        draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, true);
        draw_text(bar_x, bar_y + 18, "Grow to summon the boss");
    }
}

if (!boss_spawned) {
    draw_set_halign(fa_right);
    draw_set_color(c_white);
    draw_text(gui_w - padding, padding, "Wave " + string(wave));
    draw_set_halign(fa_left);
}

if (boss_spawned && instance_exists(boss)) {
    var boss_bar_width = 520, boss_bar_height = 22;
    var boss_bar_x = gui_w * 0.5 - boss_bar_width * 0.5, boss_bar_y = 50;
    var boss_fraction = clamp(boss.hp / boss.hp_max, 0, 1);
    draw_set_color(make_color_rgb(40, 20, 40));
    draw_rectangle(boss_bar_x, boss_bar_y, boss_bar_x + boss_bar_width, boss_bar_y + boss_bar_height, false);
    draw_set_color(make_color_rgb(220, 60, 90));
    draw_rectangle(boss_bar_x, boss_bar_y, boss_bar_x + boss_bar_width * boss_fraction, boss_bar_y + boss_bar_height, false);
    draw_set_color(c_white);
    draw_rectangle(boss_bar_x, boss_bar_y, boss_bar_x + boss_bar_width, boss_bar_y + boss_bar_height, true);
    draw_set_halign(fa_center);
    draw_text(gui_w * 0.5, boss_bar_y - 14, "THE SORCERER");
    draw_set_halign(fa_left);
}

if (instance_exists(global.player) && global.player.empowered_t > 0) {
    var power_fraction = global.player.empowered_t / EMPOWER_TIME;
    var power_width = 340, power_height = 18;
    var power_x = gui_w * 0.5 - power_width * 0.5, power_y = 88;
    draw_set_color(make_color_rgb(60, 50, 20));
    draw_rectangle(power_x, power_y, power_x + power_width, power_y + power_height, false);
    if (power_fraction > 0.25 || (current_time div 120) mod 2 == 0) {
        draw_set_color(make_color_rgb(255, 230, 90));
        draw_rectangle(power_x, power_y, power_x + power_width * power_fraction, power_y + power_height, false);
    }
    draw_set_color(c_white);
    draw_rectangle(power_x, power_y, power_x + power_width, power_y + power_height, true);
    draw_set_halign(fa_center);
    draw_text(gui_w * 0.5, power_y + power_height + 8, "POWER - bite the boss!");
    draw_set_halign(fa_left);
}

var slot_count = 3;
var slot_size = 78, slot_gap = 14;
var slots_total = slot_count * slot_size + (slot_count - 1) * slot_gap;
var slots_start_x = gui_w * 0.5 - slots_total * 0.5;
var slots_y = gui_h - slot_size - 20;

for (var slot = 0; slot < slot_count; slot++) {
    var slot_x = slots_start_x + slot * (slot_size + slot_gap);
    var has_trait = instance_exists(global.player) && slot < array_length(global.player.traits);
    var is_active = has_trait && (global.player.active_slot == slot);

    draw_set_color(is_active ? c_white : make_color_rgb(70, 74, 92));
    draw_roundrect_ext(slot_x, slots_y, slot_x + slot_size, slots_y + slot_size, 10, 10, true);

    if (has_trait) {
        var info = trait_info(global.player.traits[slot]);
        draw_set_alpha(0.22);
        draw_set_color(info.col);
        draw_roundrect_ext(slot_x + 6, slots_y + 6, slot_x + slot_size - 6, slots_y + slot_size - 6, 8, 8, false);
        draw_set_alpha(1);
        if (!draw_td_tile(info.tile, slot_x + slot_size * 0.5, slots_y + slot_size * 0.5 - 6, 3)) {
            draw_set_color(info.col);
            draw_circle(slot_x + slot_size * 0.5, slots_y + slot_size * 0.5 - 6, 18, false);
        }
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text(slot_x + slot_size * 0.5, slots_y + slot_size - 22, info.name);
        draw_set_halign(fa_left);
    }

    draw_set_color(make_color_rgb(150, 150, 160));
    draw_text(slot_x + 6, slots_y + slot_size - 20, string(slot + 1));
}

if (global.won || global.dead) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(global.won ? make_color_rgb(120, 230, 150) : make_color_rgb(240, 120, 120));
    draw_set_alpha(0.85);
    draw_rectangle(0, gui_h * 0.5 - 60, gui_w, gui_h * 0.5 + 60, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_text(gui_w * 0.5, gui_h * 0.5 - 12, global.won ? "VICTORY!" : "GAME OVER");
    draw_text(gui_w * 0.5, gui_h * 0.5 + 16, "Press R to replay");
}

if (banner_timer > 0) {
    var banner_alpha = clamp(banner_timer / 30, 0, 1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(banner_alpha);
    draw_set_color(make_color_rgb(255, 230, 120));
    draw_text_transformed(gui_w * 0.5, 130, banner_text, 3, 3, 0);
    draw_set_alpha(1);
}

if (!global.started) {
    draw_set_alpha(0.72);
    draw_set_color(make_color_rgb(15, 12, 22));
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(make_color_rgb(120, 220, 160));
    draw_text_transformed(gui_w * 0.5, gui_h * 0.26, "GLOUTON", 6, 6, 0);

    draw_set_color(c_white);
    draw_text_transformed(gui_w * 0.5, gui_h * 0.40, "Devour, grow, dominate", 1.5, 1.5, 0);

    draw_text(gui_w * 0.5, gui_h * 0.55, "Eat what is smaller than you. Flee what is bigger.");
    draw_text(gui_w * 0.5, gui_h * 0.60, "Grow to summon THE SORCERER, grab his orbs, then bite him.");

    draw_set_color(make_color_rgb(200, 200, 215));
    draw_text(gui_w * 0.5, gui_h * 0.70, "WASD / Arrows: move        Space or Click: power        1 / 2 / 3: active trait");

    var prompt_blink = 0.5 + 0.5 * sin(current_time / 250);
    draw_set_alpha(prompt_blink);
    draw_set_color(make_color_rgb(255, 230, 120));
    draw_text_transformed(gui_w * 0.5, gui_h * 0.85, "SPACE or CLICK to play", 2, 2, 0);
    draw_set_alpha(1);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);

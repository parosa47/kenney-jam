if (is_weakpoint) {
    var orb_pulse = 0.6 + 0.4 * sin(current_time / 80);
    var orb_fade = (life < 60) ? life / 60 : 1;
    if (life >= 30 || (current_time div 100) mod 2 == 0) {
        draw_set_alpha(0.30 * orb_pulse * orb_fade);
        draw_set_color(make_color_rgb(80, 220, 255));
        draw_circle(x, y, size * 2.6 * orb_pulse, false);
        draw_set_alpha(0.9 * orb_fade);
        draw_set_color(make_color_rgb(60, 200, 255));
        draw_circle(x, y, size * 1.15, false);
        draw_set_color(c_white);
        draw_circle(x, y, size * 0.65, false);
        draw_set_alpha(0.8 * orb_fade);
        draw_set_color(make_color_rgb(10, 40, 70));
        draw_circle(x, y, size * 1.15, true);
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
    exit;
}

var wobble_radius = size * (1 + 0.06 * sin(wobble));

draw_set_alpha(0.22);
draw_set_color(c_black);
draw_ellipse(x - size * 0.85, y + size * 0.5, x + size * 0.85, y + size * 0.95, false);
draw_set_alpha(1);

if (instance_exists(global.player) && size > global.player.size * HURT_MARGIN) {
    draw_set_alpha(0.35 + 0.2 * (0.5 + 0.5 * sin(current_time / 120)));
    draw_set_color(make_color_rgb(230, 60, 60));
    draw_circle(x, y, size * 1.22, true);
    draw_set_alpha(1);
}

if (trait != "none") {
    var trait_colour = trait_info(trait).col;
    draw_set_alpha(0.35);
    draw_set_color(trait_colour);
    draw_circle(x, y, size * 1.15, false);
    draw_set_alpha(1);
}

var draw_scale = (size * 2) / 16;
if (!draw_td_tile(tile, x, y, draw_scale)) {
    draw_set_color(col);
    draw_ellipse(x - wobble_radius, y - wobble_radius, x + wobble_radius, y + wobble_radius, false);
    draw_set_color(c_white);
    draw_set_alpha(0.4);
    draw_ellipse(x - wobble_radius, y - wobble_radius, x + wobble_radius, y + wobble_radius, true);
    draw_set_alpha(1);
}

if (is_boss && instance_exists(global.player) && global.player.empowered_t > 0) {
    draw_set_alpha(0.4 + 0.15 * sin(current_time / 90));
    draw_set_color(make_color_rgb(80, 150, 255));
    draw_circle(x, y, size * 1.05, false);
    draw_set_alpha(1);
}

if (is_boss && charge_state == 1) {
    draw_set_alpha(0.55 + 0.4 * sin(current_time / 40));
    draw_set_color(make_color_rgb(255, 60, 60));
    draw_circle(x, y, size * 1.15, true);
    draw_circle(x, y, size * 1.28, true);
    draw_set_alpha(1);
}

if (is_boss && hit_flash > 0) {
    draw_set_alpha(clamp(hit_flash, 0, 1) * 0.7);
    draw_set_color(c_white);
    draw_circle(x, y, size, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);

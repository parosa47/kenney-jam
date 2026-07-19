draw_set_alpha(0.25);
draw_set_color(c_black);
draw_ellipse(x - size * 0.9, y + size * 0.55, x + size * 0.9, y + size * 1.0, false);
draw_set_alpha(1);

if (speed_time > 0) {
    draw_set_alpha(0.30);
    draw_set_color(make_color_rgb(120, 235, 130));
    draw_circle(x, y, size * (1.4 + 0.15 * sin(current_time / 40)), false);
    draw_set_alpha(1);
}

if (empowered_t > 0) {
    var power_pulse = 0.5 + 0.5 * sin(current_time / 60);
    draw_set_alpha(0.4 + 0.3 * power_pulse);
    draw_set_color(make_color_rgb(255, 235, 110));
    draw_circle(x, y, size * (1.35 + 0.12 * power_pulse), false);
    draw_set_alpha(1);
}

var body_scale_x = squash_x * (1 + 0.05 * sin(wobble));
var body_scale_y = squash_y * (1 - 0.05 * sin(wobble));
var radius_x = size * body_scale_x;
var radius_y = size * body_scale_y;

var body_colour = make_color_rgb(90, 200, 160);
if (fire_time > 0) body_colour = merge_color(body_colour, make_color_rgb(255, 150, 40), 0.5 + 0.3 * sin(current_time / 60));
draw_set_color(body_colour);
draw_ellipse(x - radius_x, y - radius_y, x + radius_x, y + radius_y, false);

draw_set_color(c_white);
draw_set_alpha(0.5);
draw_ellipse(x - radius_x, y - radius_y, x + radius_x, y + radius_y, true);
draw_set_alpha(1);

var eye_offset_x = lengthdir_x(radius_x * 0.35, face_dir);
var eye_offset_y = lengthdir_y(radius_y * 0.35, face_dir);
var eye_spread = radius_x * 0.32;
var spread_x = lengthdir_x(eye_spread, face_dir + 90);
var spread_y = lengthdir_y(eye_spread, face_dir + 90);
draw_set_color(c_white);
draw_circle(x + eye_offset_x + spread_x, y + eye_offset_y + spread_y, size * 0.16, false);
draw_circle(x + eye_offset_x - spread_x, y + eye_offset_y - spread_y, size * 0.16, false);
draw_set_color(c_black);
var pupil_x = lengthdir_x(size * 0.06, face_dir);
var pupil_y = lengthdir_y(size * 0.06, face_dir);
draw_circle(x + eye_offset_x + spread_x + pupil_x, y + eye_offset_y + spread_y + pupil_y, size * 0.08, false);
draw_circle(x + eye_offset_x - spread_x + pupil_x, y + eye_offset_y - spread_y + pupil_y, size * 0.08, false);

if (fire_time > 0) {
    draw_set_color(make_color_rgb(255, 140, 40));
    draw_set_alpha(0.25);
    draw_circle(x, y, size + FIRE_RADIUS * 0.6, false);
    draw_set_alpha(1);
}

if (flash > 0) {
    draw_set_alpha(flash);
    draw_set_color(c_white);
    draw_ellipse(x - radius_x, y - radius_y, x + radius_x, y + radius_y, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
draw_set_alpha(1);

var progress = 1 - life;
var current_radius = lerp(start_radius * 0.5, start_radius * 2.6, progress);
draw_set_alpha(max(0, life));
draw_set_color(col);
draw_circle(x, y, current_radius, true);
draw_set_color(c_white);
draw_set_alpha(1);

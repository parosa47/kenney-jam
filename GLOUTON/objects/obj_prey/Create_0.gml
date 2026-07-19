depth = -y;

size = 14;
col = make_color_rgb(150, 150, 160);
trait = "none";
tile = 108;
mass = mass_from_size(size);

dir = random(360);
spd = random_range(0.6, 1.4);
wobble = random(6.28);
turn_timer = irandom_range(30, 90);

is_weakpoint = false;
wp_boss = noone;
life = 0;
vx = 0;
vy = 0;

is_boss = false;
hp = 1;
hp_max = 1;
boss_phase = 0;
hit_flash = 0;
orb_t = 60;
charge_t = 260;
charge_state = 0;
charge_time = 0;
charge_dir = 0;
bite_cd = 0;

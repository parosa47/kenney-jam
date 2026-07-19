#macro GAME_W 3200
#macro GAME_H 1800
#macro VIEW_W 1366
#macro VIEW_H 768

#macro SIZE_K 2.4
#macro MASS_START 100
#macro MASS_MIN 60
#macro START_SIZE 24
#macro WIN_SIZE 110

#macro EAT_MARGIN 1.12
#macro HURT_MARGIN 1.12

#macro SPEED_SMALL 4.6
#macro SPEED_BIG 3.0
#macro SPEED_TRAIT_MULT 1.65
#macro SPEED_BOOST_TIME 90
#macro SPEED_BOOST_CD 150

#macro ZOOM_MAX 1.85
#macro ZOOM_DIV 60

#macro WALL_TILE 40
#macro WALL_THICK 3
#macro WALL_INSET (WALL_THICK * 16)

#macro START_PREY 38
#macro SPAWN_EVERY 40
#macro WAVE_TIME 1200
#macro WAVE_MAX 8
#macro THREAT_CHANCE_MIN 0.10
#macro THREAT_CHANCE_MAX 0.55

#macro DASH_SPEED 14
#macro DASH_TIME 10
#macro DASH_CD 40
#macro FIRE_TIME 60
#macro FIRE_CD 90
#macro FIRE_RADIUS 46

#macro ABSORB_GAIN 0.85
#macro BOSS_TRIGGER 105
#macro BOSS_HP 520
#macro BOSS_RADIUS 100
#macro BOSS_CHASE 0.9
#macro WP_COUNT 1
#macro WP_SIZE 22
#macro ORB_LIFE 720
#macro ORB_INTERVAL 600
#macro EMPOWER_TIME 270
#macro BITE_DAMAGE 20
#macro BITE_CD 60
#macro FIRE_DAMAGE 0.6
#macro CHARGE_INTERVAL 260
#macro CHARGE_TELEGRAPH 45
#macro CHARGE_DURATION 26
#macro CHARGE_SPEED 9

function build_prey_types() {
    return [
        { key: "rat",      name: "Rat",       col: make_color_rgb(150, 120,  90), radius: 10, trait: "none",  weight: 10, tile: 123 },
        { key: "spider",   name: "Araignee",  col: make_color_rgb(160, 110,  70), radius: 13, trait: "none",  weight:  8, tile: 122 },
        { key: "slime",    name: "Slime",     col: make_color_rgb( 90, 200, 140), radius: 16, trait: "none",  weight:  7, tile: 108 },
        { key: "goblin",   name: "Gobelin",   col: make_color_rgb( 90, 200,  90), radius: 18, trait: "speed", weight:  4, tile: 112 },
        { key: "torch",    name: "Torche",    col: make_color_rgb(240, 140,  40), radius: 15, trait: "fire",  weight:  4, tile: 127 },
        { key: "skeleton", name: "Squelette", col: make_color_rgb(210, 210, 200), radius: 22, trait: "none",  weight:  4, tile:  86 },
        { key: "knight",   name: "Chevalier", col: make_color_rgb(170, 185, 210), radius: 26, trait: "dash",  weight:  3, tile:  96 },
        { key: "brute",    name: "Brute",     col: make_color_rgb(170, 110,  80), radius: 46, trait: "none",  weight:  2, tile:  85 },
    ];
}

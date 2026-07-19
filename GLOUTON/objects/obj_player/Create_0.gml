depth = -y;

mass = MASS_START;
size = size_from_mass(mass);
game_score = 0;

traits = [];
active_slot = 0;

face_dir = 0;
moving = false;
wobble = 0;

squash_x = 1;
squash_y = 1;

hit_cooldown = 0;
flash = 0;

dash_time = 0;
dash_cooldown = 0;
dash_dir = 0;

fire_time = 0;
fire_cooldown = 0;

speed_time = 0;
speed_cooldown = 0;

empowered_t = 0;

gain_trait = function(trait_key) {
    for (var i = 0; i < array_length(traits); i++) {
        if (traits[i] == trait_key) {
            active_slot = i;
            return;
        }
    }
    if (array_length(traits) >= 3) array_delete(traits, 0, 1);
    array_push(traits, trait_key);
    active_slot = array_length(traits) - 1;
};

absorb = function(gained_mass, gained_trait, effect_x, effect_y, effect_colour) {
    mass += gained_mass * ABSORB_GAIN;
    size = size_from_mass(mass);
    game_score += round(gained_mass);
    squash_x = 1.28;
    squash_y = 0.78;
    make_fx(effect_x, effect_y, effect_colour, 14);
    play_sound("snd_eat");
    if (gained_trait != "none") gain_trait(gained_trait);
    with (obj_game) shake = max(shake, 2);
};

take_hit = function(threat_mass) {
    if (hit_cooldown > 0) return;
    hit_cooldown = 50;
    var loss = min(mass * 0.45, threat_mass * 0.6);
    mass = max(MASS_MIN, mass - loss);
    size = size_from_mass(mass);
    squash_x = 0.75;
    squash_y = 1.3;
    flash = 1;
    play_sound("snd_hurt");
    with (obj_game) shake = max(shake, 9);
    if (mass <= MASS_MIN + 0.5) global.dead = true;
};

use_trait = function() {
    if (array_length(traits) == 0) return;
    var active_trait = traits[active_slot];
    if (active_trait == "dash" && dash_cooldown <= 0) {
        dash_time = DASH_TIME;
        dash_cooldown = DASH_CD;
        dash_dir = face_dir;
        squash_x = 1.3;
        squash_y = 0.8;
        play_sound("snd_dash");
    } else if (active_trait == "fire" && fire_cooldown <= 0) {
        fire_time = FIRE_TIME;
        fire_cooldown = FIRE_CD;
        play_sound("snd_fire");
    } else if (active_trait == "speed" && speed_cooldown <= 0) {
        speed_time = SPEED_BOOST_TIME;
        speed_cooldown = SPEED_BOOST_CD;
        play_sound("snd_dash");
    }
};

function trait_info(trait_key) {
    switch (trait_key) {
        case "dash":  return { name: "Charge", col: make_color_rgb(120, 180, 255), tile:  96 };
        case "fire":  return { name: "Fire",   col: make_color_rgb(240, 140,  40), tile: 127 };
        case "speed": return { name: "Speed",  col: make_color_rgb(120, 230, 120), tile: 112 };
        default:      return { name: "-",       col: make_color_rgb( 70,  70,  80), tile: -1 };
    }
}

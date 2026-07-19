# GLOUTON

A fast arcade slime-grower made for the **Kenney Jam** (theme: *scale*).
Eat what is smaller than you, grow bigger, flee what is bigger — then take on **THE SORCERER**.

## Play

Play in the browser on itch.io: _add link after publishing_

## Controls

| Action | Keys |
| --- | --- |
| Move | WASD / Arrow keys / ZQSD |
| Use active ability | Space or Left click |
| Switch ability slot | 1 / 2 / 3 |
| Replay (end screen) | R |

## How it plays

- You are a slime. Touch a smaller creature to devour it and grow — the camera zooms out as you scale up.
- Bigger creatures hurt you; flee them.
- Devour a creature with a **coloured halo** to gain an active ability (3 slots max, newest replaces oldest):
  - **Charge** (Knight) — a quick dash
  - **Fire** (Torch) — a burning aura
  - **Speed** (Goblin) — a short speed burst
- Waves ramp the difficulty. Grow enough and **THE SORCERER** appears:
  - Grab a glowing orb to become **empowered** — the boss turns blue and flees. Bite it while empowered.
  - You can also burn it with the **Fire** aura.
  - Defeat it to win.

## Built with

**GameMaker LTS 2026** (GML), exported to **HTML5**.

## Credits

Art and audio by **Kenney** ([kenney.nl](https://kenney.nl)) — CC0:

- Sprites: **Tiny Dungeon**
- Sound & music: **Impact Sounds**, **Interface Sounds**, **RPG Audio**, **Music Jingles**

Game design and code: Pier-Alexandre.

## Build (HTML5)

Open `GLOUTON/GLOUTON.yyp` in GameMaker, set the target to **HTML5**, then *Create Executable*.
Zip the output (with `index.html` at the root of the zip) and upload it to itch.io as an **HTML** project.

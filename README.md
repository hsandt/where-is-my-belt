# Where is my Belt?

[itch.io page](https://komehara.itch.io/where-is-my-belt)

![Gameplay demo GIF: teacher pull their pants while moving their chalk on the whiteboard](doc/where-is-my-belt_v0.2_gameplay_demo_6s.png?raw=true)

**Where is my Belt?** is a twitch game made for [Ludum Dare 50](https://ldjam.com/events/ludum-dare/50/) on the theme "Delay the inevitable" in the Extra category.

In this game, you play as a teacher who forgot their belt and must run a class while keeping their pants up. But beware: the pupils are looking at you...

## Screenshots

INSERT HERE

## Controls

You can play with keyboard or gamepad with those inputs:

| Keyboard                 | Gamepad                | Action                                           |
|--------------------------|------------------------|--------------------------------------------------|
| Up/down arrows           | D-pad up/down          | Move chalk up/down to dodge obstacles            |
| Z/C/N                    | Face button up/down    | PICO-8 "O": Confirm (menu), pull pants (in-game) |
| X/V/M                    | Face button left/right | PICO-8 "X": Cancel (menu)                        |
| Enter                    | Start                  | Open PICO-8 pause menu                           |
| Alt+Enter                |                        | Toggle fullscreen                                |
| Ctrl+R (standalone only) |                        | Restart current cartridge                        |

If you gamepad mapping is not correct when playing with the native PC binaries, you can customize it with [SDL2 Gamepad Tool](https://www.generalarcade.com/gamepadtool) and copy-paste the configuration line into sdl_controllers.txt in PICO-8's [configuration directory](https://pico-8.fandom.com/wiki/Configuration). For instance, the Logicool Gamepad F310 had Open PICO-8 menu mapped to Right Trigger, so I remapped it to Start instead.

## Development notes

The Extra category extends the deadline by 16 days, but I started working quite a time after the standard LD 50 was over, so in fact, I only spent 6 days (26h) on this project.

## Compatibility

Works with PICO-8 0.2.2.

## Build

Instructions are similar to https://github.com/hsandt/sonic-pico8, except the game has only one cartridge named "main".

## Test

Instructions are similar to https://github.com/hsandt/sonic-pico8, except the game has only one cartridge named "main".

## References

* Nobuta wo Produce (Japanese drama series) for the teacher touching his pants

## Tools and process

* Tilemap and audio editing made with PICO-8
* Sprites made with Aseprite
* Code written with Sublime Text

I used my own PICO-8 framework, [pico-boots](https://github.com/hsandt/pico-boots).

## Credits

* komehara - Game design, Programming, Art, Audio

## License

### Code

The [LICENSE](LICENSE) file at the root applies to the main code.

The PICO8-WTK submodule contains its own license.

The original picolove and gamax92's fork are under zlib license.

The `npm` folder has its own MIT license because I adapted a script from the `luamin` package. After installing npm packages, you will also see package-specific licenses in `node_modules`.

### Assets

All sprites and sounds are [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/).

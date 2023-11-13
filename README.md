# ZMK config

This is my custom corne low profile keyboard ZMK firmware configuration.

## Example command

`west build -d build/left -b nice_nano_v2 -- -DZMK_CONFIG=../../zmk-config/config/ -DSHIELD=corne_left`

## Todo

- build script catch west build errors
- use dockerfile with custom .bashrc (debug) (?)
- faster builds `west build -d build/left` after first run (?)

## Links

[urob's zmk-config](https://github.com/urob/zmk-config)
[zmk-nodefree-config](https://github.com/urob/zmk-nodefree-config)
[ZMK Documentation](https://zmk.dev/docs)
[keymap-drawer](https://github.com/caksoylar/keymap-drawer)

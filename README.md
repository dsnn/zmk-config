# ZMK config

This is my custom corne low profile keyboard ZMK firmware configuration.

Tools is in script folder.

## Reminders 

- check [zmk blog](https://zmk.dev/blog) for latest news, updates and versions.
- update local clones (zmkfirmware, zmk-nodefree-config, zmk-locale-generator, ...)

## Example command

`west build -d build/left -b nice_nano_v2 -- -DZMK_CONFIG=../../zmk-config/config/ -DSHIELD=corne_left`

## Todo

- build script catch west build errors
- faster builds `west build -d build/left` after first run (?)
- local toochain with nix (WIP) (or custom dockerfile with aliases, justfile, commands etc)
- keymap-drawer

## Links

[zmk-locale-generator](https://zmk.dev/blog/2024/01/05/zmk-tools#zmk-locale-generator)
[zmk-nodefree-config](https://github.com/urob/zmk-nodefree-config)
[zmk documentation](https://zmk.dev/docs)
[urob's zmk-config](https://github.com/urob/zmk-config)
[keymap-drawer](https://github.com/caksoylar/keymap-drawer)

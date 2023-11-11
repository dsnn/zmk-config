# ZMK config

## Example command

`west build -d build/left -b nice_nano_v2 -- -DZMK_CONFIG=../../zmk-config/config/ -DSHIELD=corne_left`

## TODO

- use dockerfile with custom .bashrc (debug) (?)
- faster builds `west build -d build/left` after first run (?)

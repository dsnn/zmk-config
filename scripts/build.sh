west build -d build/left -b nice_nano_v2 -- -DZMK_CONFIG=../../zmk-config/config/ -DSHIELD=corne_left nice_view nice_view_adapter
west build -d build/right -b nice_nano_v2 -- -DZMK_CONFIG=../../zmk-config/config/ -DSHIELD=corne_right nice_view nice_view_adapter
echo 'cleanup'
rm /workspace/zmk-config/out/left.uf2
rm /workspace/zmk-config/out/right.uf2
echo 'copy files'
cp build/right/zephyr/zmk.uf2 /workspace/zmk-config/out/right.uf2
cp build/left/zephyr/zmk.uf2 /workspace/zmk-config/out/left.uf2

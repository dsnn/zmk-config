#!/usr/bin/env bash

# Defaults
BOARD_NAME="nice_nano_v2"
SHIELD="corne"
CLEAR_CACHE=FALSE
ZEPHYR_VERSION='3.2'
LOG_DIR="/tmp"
DOCKER_CONFIG_DIR="/workspaces/zmk-config"
DOCKER_ZMK_DIR="/workspaces/zmk"
HOST_CONFIG_DIR="/Users/dsn/projects/zmk/zmk-config"
HOST_ZMK_DIR="/Users/dsn/projects/zmk/zmk"
OUTPUT_DIR="/Users/dsn/projects/zmk/zmk-config/out"
DOCKER_IMG="zmkfirmware/zmk-dev-arm:$ZEPHYR_VERSION"
DOCKER_CMD="docker"

# helpers
function echo-debug { echo "$@" | sed -e "s%$HOME%~%g" -e "s%$DOTFILES%.%g"; }
function echo-info { printf "\r\033[2K\033[0;34m[INFO]\033[0m %s\n" "$*"; }
function echo-skip { printf "\r\033[2K\033[38;05;240m[SKIP]\033[0m %s\n" "$*"; }
function echo-ok { printf "\r\033[2K\033[0;32m[OK]\033[0m %s\n" "$*"; }
function echo-fail { printf "\r\033[2K\033[0;31m[FAIL]\033[0m %s\n" "$*"; }

# +--------------------+
# | BUILD THE FIRMWARE |
# +--------------------+

echo-info "Build zmk firmware"

DOCKER_RUN_CMD="docker run --rm \
--mount type=bind,source=$HOST_ZMK_DIR,target=$DOCKER_ZMK_DIR \
--mount type=bind,source=$HOST_CONFIG_DIR,target=$DOCKER_CONFIG_DIR,readonly \
--mount type=volume,source=zmk-root-user-$ZEPHYR_VERSION,target=/root \
--mount type=volume,source=zmk-zephyr-$ZEPHYR_VERSION,target=$DOCKER_ZMK_DIR/zephyr \
--mount type=volume,source=zmk-zephyr-modules-$ZEPHYR_VERSION,target=$DOCKER_ZMK_DIR/modules \
--mount type=volume,source=zmk-zephyr-tools-$ZEPHYR_VERSION,target=$DOCKER_ZMK_DIR/tools"

# Reset volumes
if [[ $CLEAR_CACHE = true ]]; then
	docker volume rm $(docker volume ls -q | grep "^zmk-.*-$ZEPHYR_VERSION$")
	echo-ok "Docker volumes removed"
fi

# Update west if needed
OLD_WEST="/root/west.yml.old"
$DOCKER_RUN_CMD -w "$DOCKER_ZMK_DIR" "$DOCKER_IMG" /bin/bash -c " \
  if [[ ! -f .west/config ]]; then west init -l app/; fi \
  && if [[ -f $OLD_WEST ]]; then md5_old=\$(md5sum $OLD_WEST | cut -d' ' -f1); fi \
  && [[ \$md5_old != \$(md5sum app/west.yml | cut -d' ' -f1) ]] \
  && west update \
  && cp app/west.yml $OLD_WEST"

# Build parameters
DOCKER_PREFIX="$DOCKER_RUN_CMD -w $DOCKER_ZMK_DIR/app $DOCKER_IMG"

compile_board() {
	BUILD_DIR="build/${1}" #
	FILE_NAME="${SHIELD}_${BOARD_NAME}_$1"
	LOGFILE="$LOG_DIR/zmk_build_$FILE_NAME.log"

	echo-info "Start compiling ${FILE_NAME}"

	# ... -d builds/<left/right> -b nice_nano_v2 ... -DSHIELD=corne_<left/right>
	$DOCKER_PREFIX west build -d "${BUILD_DIR}" -b $BOARD_NAME $WEST_OPTS \
		-- -DZMK_CONFIG="$DOCKER_CONFIG_DIR/config" -DSHIELD="${SHEILD}_${1}" -Wno-dev >"$LOGFILE" 2>&1

	echo-ok "Done compiling ${FILE_NAME} "

	if [[ $? -eq 0 ]]; then
		echo-info "Build log saved to \"$LOGFILE\"."

		OUTPUT="$OUTPUT_DIR/${FILE_NAME}.uf2"

		if [[ -f $OUTPUT && ! -L $OUTPUT ]]; then
			mv "$OUTPUT" "$OUTPUT.bak"
			echo-ok "${OUTPUT} -> ${OUTPUT}.bak"
		fi

		cp "$HOST_ZMK_DIR/app/$BUILD_DIR/zephyr/zmk.uf2" "$OUTPUT"

		echo-ok "Generated ${OUTPUT}"

	else
		echo
		cat "$LOGFILE"
		echo-fail "Error: ${1} failed"
	fi
}

cd "$HOST_ZMK_DIR/app"

# corne_nice_nano_v2_left.uf2
# corne_nice_nano_v2_right.uf2

for board in left right; do
	compile_board $board
done

export LS_OPTIONS='-F --color=auto'

export WORKSPACE_ROOT="$HOME/workspace"
export WORKSPACE_DIR="$HOME/workspace/zmk"

export CONFIG_DIR="$HOME/workspace/zmk-config"
export OUTPUT_DIR="$CONFIG_DIR/out"

export ZMK_BUILD_DIR="$WORKSPACE_DIR/app/build"
export ZMK_LEFT_BUILD_DIR="$ZMK_BUILD_DIR/left/zephyr"
export ZMK_RIGHT_BUILD_DIR="$ZMK_BUILD_DIR/right/zephyr"

alias ls='ls $LS_OPTIONS'

alias cfw='cd $WORKSPACE_ROOT'
alias cfz='cd $WORKSPACE_DIR'

alias cfc='cd $CONFIG_DIR'
alias cfo='cd $OUTPUT_DIR'

alias cfb='cd $ZMK_BUILD_DIR'
alias cfl='cd $ZMK_LEFT_DIR'
alias cfr='cd $ZMK_RIGHT_DIR'

if [ -f "$WORKSPACE_DIR/zephyr/zephyr-env.sh" ]; then
	source "$WORKSPACE_DIR/zephyr/zephyr-env.sh"
fi

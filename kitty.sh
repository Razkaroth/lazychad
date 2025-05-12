#!/run/current-system/sw/bin/sh

# Check if the terminal is Kitty using the KITTY_PID environment variable
if [[ -n "$KITTY_PID" && -z "$TMUX" ]]; then
  # Set the padding and margin to 0 to remove the extra padding
  kitty @ set-spacing padding=0 margin=0
  nvim "$@"
  kitty @ set-spacing padding=default margin=default
else
  # Do nothing if not Kitty
  nvim "$@"
fi

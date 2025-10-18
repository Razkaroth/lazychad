import os


# This set's a one way path to setup snippets that are shared both on typescript and tsx lags.
# Here we set sources of thruth between runtimes.


# Copy all from typescript to tsx
os.system(
    "cp -r /home/raz/.config/nvim/snippets/typescript /home/raz/.config/nvim/snippets/tsx"
)

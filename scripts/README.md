# Scripts

| Script                                                         | Description                                                                                                                                                            |
| -------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [bw-unlock](./src/bw-unlock.php)                               | Interactively unlocks [BitWarden cli](https://bitwarden.com/help/cli/)'s session and stores the generated key as a variable (like the cli suggests).                   |
| [gbsavesync](./src/gbsavesync.php)                             | Copies downloaded emulator savefiles into common locations (currently VBA-M and Retroarch). Uses my conversion tool [gbsaveconv](https://github.com/mnlcz/gbsaveconv). |
| [gnome-restore-keybindings.sh](./gnome-restore-keybindings.sh) | Loads the keybindings stored [here](../wm/mutter) to the current GNOME system.                                                                                         |
| [gnome-save-keybindings.sh](./gnome-save-keybindings.sh)       | Dumps the current GNOME's keybindings [here](../wm/mutter).                                                                                                            |
| [init-tmux.sh](./init-tmux.sh)                                 | Init script for tmux, loads sessions and windows.                                                                                                                      |
| [updates](./src/updates.php)                                   | Checks and prints if the defined package managers (like `dnf`, `cargo`, etc) have updates.                                                                             |

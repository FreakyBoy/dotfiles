# Dotfiles

My personal dotfiles configuration for macOS.

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/FreakyBoy/dotfiles.git ~/dotfiles
   ```

2. Run the installation script:
   ```bash
   cd ~/dotfiles
   ./install.sh
   ```

## Files included

- `.zshrc` - Zsh shell configuration
- `.gitconfig` - Git configuration
- `.aerospace.toml` - [AeroSpace](https://github.com/nikitabobko/AeroSpace) window manager configuration
- `.config/borders/bordersrc` - [JankyBorders](https://github.com/FelixKratz/JankyBorders) configuration
  - Rounded window borders with 6px width
  - Active window color: `#da614e` (orange)
  - Inactive window color: `#414550` (dark gray)
- `.config/sketchybar/` - [SketchyBar](https://github.com/FelixKratz/SketchyBar) status bar configuration
- `install.sh` - Installation script that creates symlinks

## Updating

To update your dotfiles:

1. Make changes to the files in `~/dotfiles/`
2. Commit and push changes:
   ```bash
   cd ~/dotfiles
   git add .
   git commit -m "Update dotfiles"
   git push
   ```

## Backup

The installation script will backup your existing dotfiles before creating symlinks.
#!/bin/bash

# Dotfiles installation script
# This script creates symlinks from your home directory to the dotfiles in this repository

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing dotfiles from $DOTFILES_DIR"

# Function to create symlinks
link_file() {
    local src="$1"
    local dst="$2"
    
    # Remove existing file/symlink
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        echo "Removing existing $dst"
        rm -rf "$dst"
    fi
    
    echo "Linking $src to $dst"
    ln -s "$src" "$dst"
}

# Link dotfiles
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
fi

if [ -f "$DOTFILES_DIR/.bashrc" ]; then
    link_file "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
fi

if [ -f "$DOTFILES_DIR/.vimrc" ]; then
    link_file "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
fi

if [ -f "$DOTFILES_DIR/.gitconfig" ]; then
    link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
fi

# Link AeroSpace config
if [ -f "$DOTFILES_DIR/.aerospace.toml" ]; then
    link_file "$DOTFILES_DIR/.aerospace.toml" "$HOME/.aerospace.toml"
fi

# Link JankyBorders config
if [ -d "$DOTFILES_DIR/.config/borders" ]; then
    mkdir -p "$HOME/.config/borders"
    if [ -f "$DOTFILES_DIR/.config/borders/bordersrc" ]; then
        link_file "$DOTFILES_DIR/.config/borders/bordersrc" "$HOME/.config/borders/bordersrc"
    fi
fi

# Link SketchyBar config
if [ -d "$DOTFILES_DIR/.config/sketchybar" ]; then
    mkdir -p "$HOME/.config"
    link_file "$DOTFILES_DIR/.config/sketchybar" "$HOME/.config/sketchybar"
fi

echo "Dotfiles installation complete!"
echo "You may need to restart your terminal or run 'source ~/.zshrc' to apply changes."
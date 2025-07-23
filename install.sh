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

echo "Dotfiles installation complete!"
echo "You may need to restart your terminal or run 'source ~/.zshrc' to apply changes."
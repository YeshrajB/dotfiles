#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dotfiles"

# ------------------------------
# Step 1: Symlink Vim and Tmux files
# ------------------------------
declare -A FILES_TO_SYMLINK=(
    ["$DOTFILES_DIR/vim/vimrc"]="$HOME/.vimrc"
    ["$DOTFILES_DIR/tmux/tmux.conf"]="$HOME/.tmux.conf"
    ["$DOTFILES_DIR/git/gitconfig"]="$HOME/.gitconfig"
)

echo "Creating symlinks..."
for src in "${!FILES_TO_SYMLINK[@]}"; do
    dest="${FILES_TO_SYMLINK[$src]}"
    
    # Backup existing file if it exists
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Backing up existing $dest -> $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    # Ensure parent directory exists
    mkdir -p "$(dirname "$dest")"

    # Create symlink
    ln -s "$src" "$dest"
    echo "Linked $dest -> $src"
done

# ------------------------------
# Step 2: Install vim-plug
# ------------------------------
VIM_PLUG_PATH="$HOME/.vim/autoload/plug.vim"

if [ ! -f "$VIM_PLUG_PATH" ]; then
    echo "Downloading vim-plug for Vim..."
    curl -fLo "$VIM_PLUG_PATH" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# ------------------------------
# Step 3: Install Vim plugins
# ------------------------------
echo "Installing Vim plugins..."
vim +PlugInstall +qall

echo "Done!"

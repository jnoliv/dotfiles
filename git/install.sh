# Install git
pkexec apt install -y git

# Create symbolic links to git dotfiles.
mkdir -p ~/.config/git/
ln -fns -T "$SCRIPT_DIR/git/gitconfig" ~/.config/git/config

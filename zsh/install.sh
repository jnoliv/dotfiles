# Install Zsh and make it default shell.
pkexec apt install -y zsh
chsh -s $(which zsh)

# Set up fonts directory.
mkdir -p ~/.fonts ~/.local/share/fonts
ln -fns -T ~/.local/share/fonts ~/.fonts

# Download JetBrainsMono Nerd Font Mono.
pushd ~/.fonts > /dev/null
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
tar -xf JetBrainsMono.tar.xz JetBrainsMonoNerdFontMono-Regular.ttf
rm JetBrainsMono.tar.xz
popd > /dev/null

# Refresh font cache.
fc-cache -f

# Create symbolic links to zsh dotfiles.
ln -fns -T "$SCRIPT_DIR/zsh/.zshenv" ~/.zshenv
ln -fns -T "$SCRIPT_DIR/zsh" ~/.config/zsh

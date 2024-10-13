#!/bin/bash

# Install the package if not exist
check_and_install() {
    package="$1"
    
    if dpkg -l | grep -q "^ii  $package"; then
        echo "Already installed, skip! [$package]"
    else
        sudo apt-get install -y "$package"
        echo "Installation has been completed [$package]"
    fi
}

# Install neovim
install_neovim() {
    NVIM_PATH="/opt/nvim-linux64"

    if [ -d $NVIM_PATH ] && [ "$(ls -A $NVIM_PATH)" ]; then
        echo "Already installed, skip! [Neovim]"
    else
        # Download and install neovim
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
        sudo rm -rf $NVIM_PATH
        sudo tar -C /opt -xzf nvim-linux64.tar.gz
        sudo rm nvim-linux64.tar.gz

        # Add neovim"s environment variable to the .bashrc file
        if grep -Fxq "export PATH=\"\$PATH:/opt/nvim-linux64/bin\"" ~/.bashrc > /dev/null; then
            echo "Existing environment variable configuration detected, skip! [Neovim]"
        else
            echo "" >> ~/.bashrc # Add a new line
            echo "export PATH=\"\$PATH:/opt/nvim-linux64/bin\"" >> ~/.bashrc
            echo "Path environment variable has been configured [Neovim]"
        fi
        
        # Finish
        echo "Installation has been completed [Neovim]"
    fi
}

# Make the .bashrc file source the .bashrc_aliases file
post_setup_aliases() { 
    if grep -Fxq "if [ -f \$HOME/.bashrc_aliases ]; then" ~/.bashrc > /dev/null; then
        echo "Existing source configuration detected, skip! [Aliases]"
    else
        echo "" >> ~/.bashrc # Add a new line
        echo -e '# include .bashrc_aliases if it exists\nif [ -f $HOME/.bashrc_aliases ]; then\n    . $HOME/.bashrc_aliases\nfi' >> ~/.bashrc
        echo "Souce has been configured [Aliases]"
    fi
}

# ============ Installation Begins Here ============ 

# Update the package list
echo "Updating package lists..."
sudo apt-get update > /dev/null

# Install python-is-python3
check_and_install python-is-python3

# Install build-essential
check_and_install build-essential

# Install git
check_and_install git

# Install htop
check_and_install htop

# Install screen
check_and_install screen

# Install tmux
check_and_install tmux

# Install vim
check_and_install vim

# Install nvim
install_neovim

# Install stow for link dotfiles
check_and_install stow

# Link all dotfiles to the home directory
stow */

# Post setup for .bashrc_aliases
post_setup_aliases


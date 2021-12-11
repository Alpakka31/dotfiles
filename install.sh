#!/bin/sh

echo "Installing dotfiles"
cp -R .config ~/
cp -R Pictures ~/
cp -R .fonts ~/
cp .xinitrc ~/
cp .zprofile ~/
cp .zshenv ~/
cp .zshrc ~/

#!/bin/bash

path=~/.local/bin/nvim
if [ ! -f "$path" ]; then
  mkdir -p $(dirname "$path") 
  curl -o "$path" -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
  chmod +x "$path"
fi

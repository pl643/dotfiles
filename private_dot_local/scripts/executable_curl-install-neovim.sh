cd /tmp
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar -C ~/.local/bin -xzf nvim-linux-x86_64.tar.gz
ln -sf ~/.local/bin/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim

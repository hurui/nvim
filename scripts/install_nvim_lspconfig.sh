#!/usr/bin/env sh

set -eu

repo_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim/pack/vendor/start/nvim-lspconfig"

if [ -d "$repo_dir/.git" ]; then
  git -C "$repo_dir" pull --ff-only
  exit 0
fi

mkdir -p "$(dirname "$repo_dir")"
git clone --depth=1 https://github.com/neovim/nvim-lspconfig.git "$repo_dir"

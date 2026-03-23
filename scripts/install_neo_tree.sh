#!/usr/bin/env sh

set -eu

base_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim/pack/vendor/start"

clone_or_update() {
  repo_url="$1"
  repo_name="$2"
  repo_branch="${3:-}"
  repo_dir="$base_dir/$repo_name"

  if [ -d "$repo_dir/.git" ]; then
    git -C "$repo_dir" pull --ff-only
    return
  fi

  mkdir -p "$base_dir"

  if [ -n "$repo_branch" ]; then
    git clone --depth=1 --branch "$repo_branch" "$repo_url" "$repo_dir"
    return
  fi

  git clone --depth=1 "$repo_url" "$repo_dir"
}

clone_or_update https://github.com/nvim-lua/plenary.nvim.git plenary.nvim
clone_or_update https://github.com/MunifTanjim/nui.nvim.git nui.nvim
clone_or_update https://github.com/nvim-tree/nvim-web-devicons.git nvim-web-devicons
clone_or_update https://github.com/nvim-neo-tree/neo-tree.nvim.git neo-tree.nvim v3.x

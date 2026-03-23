vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local ok, neo_tree = pcall(require, "neo-tree")
if not ok then
  return
end

neo_tree.setup({
  close_if_last_window = false,
  enable_git_status = true,
  enable_diagnostics = true,
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    follow_current_file = {
      enabled = true,
    },
    hijack_netrw_behavior = "open_default",
  },
  window = {
    position = "left",
    width = 30,
    mappings = {
      ["<space>"] = "none",
      ["l"] = "open",
      ["h"] = "close_node",
    },
  },
})

vim.keymap.set("n", "-", "<Cmd>Neotree filesystem reveal left toggle<CR>", { desc = "Toggle neo-tree" })
vim.keymap.set("n", "<leader>o", "<Cmd>Neotree filesystem reveal left toggle<CR>", { desc = "Toggle neo-tree" })

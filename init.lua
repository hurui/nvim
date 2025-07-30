-- Disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- disable warning
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "nvi"

vim.o.smartindent = true
vim.o.smarttab = true
vim.o.breakindent = true
-- 将 Tab 键输入的字符扩展为空格
vim.o.expandtab = true
vim.o.wrap = true
-- 设置 Tab 字符的显示宽度为 2 个空格。
vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.opt.history = 1000
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.opt.fixeol = true

vim.opt.signcolumn = "number"

--- Setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		-- theme
		{
			"catppuccin/nvim",
			name = "catppuccin",
			lazy = false,
			priority = 1000,
			config = function()
				require("config.catppuccin")
			end,
		},
		-- file explorer
		{
			"nvim-tree/nvim-tree.lua",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("nvim-tree").setup({
					git = {
						enable = true,
					},
					filters = { custom = { "^.git$" } },
					update_focused_file = {
						enable = true, -- 启用当文件焦点改变时更新文件树
						update_root = true, -- 如果当前文件不在当前显示的根目录下，是否更新文件树的根目录
						ignore_list = {}, -- 忽略更新的文件类型或路径模式
					},
				})
				vim.keymap.set("n", "<C-h>", "<cmd>NvimTreeToggle<CR>", { silent = true, noremap = true })
			end,
		},
		-- lsp
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = { "rust_analyzer", "tailwindcss", "ts_ls", "harper_ls", "eslint" },
				automatic_enable = {
					exclude = { "rust_analyzer" },
				},
			},
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				"neovim/nvim-lspconfig",
			},
		},
		-- syntax highlight
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "master",
			lazy = false,
			build = ":TSUpdate",
		},
		-- format
		{
			"stevearc/conform.nvim",
			opts = {},
			config = function()
				require("config.conform")
			end,
		},
		-- completion
		{
			"saghen/blink.cmp",
			-- optional: provides snippets for the snippet source
			dependencies = { "rafamadriz/friendly-snippets" },

			-- use a release tag to download pre-built binaries
			version = "1.*",
			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				-- See :h blink-cmp-config-keymap for defining your own keymap
				keymap = { preset = "default" },

				appearance = {
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = "mono",
				},

				-- (Default) Only show the documentation popup when manually triggered
				completion = { documentation = { auto_show = false } },

				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},

				fuzzy = { implementation = "prefer_rust_with_warning" },
			},
			opts_extend = { "sources.default" },
		},

		-- fuzzy finder
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("config.telescope")
			end,
		},
		-- tailwind
		{
			"luckasRanarison/tailwind-tools.nvim",
			name = "tailwind-tools",
			build = ":UpdateRemotePlugins",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"nvim-telescope/telescope.nvim", -- optional
				"neovim/nvim-lspconfig", -- optional
			},
			opts = {}, -- your configuration
		},
		-- git
		{ "lewis6991/gitsigns.nvim", opts = {} },
		-- rust
		{
			"mrcjkb/rustaceanvim",
			version = "^6", -- Recommended
			lazy = false, -- This plugin is already lazy
		},
		-- inlay_hint
		{
			"chrisgrieser/nvim-lsp-endhints",
			event = "LspAttach",
			opts = {}, -- required, even if empty
		},
		-- session manager
		{
			"olimorris/persisted.nvim",
			opts = {},
		},
	},
	install = {},
	checker = { enabled = true },
})

vim.keymap.set({ "n", "i", "v" }, "<leader>w", "<cmd>w<CR><Esc>", { noremap = true })

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt", lsp_format = "fallback" },
		typescript = { "prettier" },
		astro = { "prettier" },
		css = { "prettier" },
		mdx = { "prettier" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

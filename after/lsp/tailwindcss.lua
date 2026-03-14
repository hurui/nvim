local util = require("config.lsp_util")

return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    "astro",
    "css",
    "heex",
    "html",
    "javascript",
    "javascriptreact",
    "svelte",
    "typescript",
    "typescriptreact",
    "vue",
  },
  settings = {
    tailwindCSS = {
      classFunctions = { "clsx", "cn", "cva", "tw" },
    },
  },
  on_attach = function(client)
    util.disable_formatting(client)
  end,
  on_new_config = function(new_config, root_dir)
    new_config.cmd = util.resolve_cmd("tailwindcss-language-server", { "--stdio" }, root_dir)
  end,
}

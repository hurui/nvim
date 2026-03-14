local util = require("config.lsp_util")

return {
  cmd = function(dispatchers, config)
    local cmd = util.resolve_executable("oxfmt", (config or {}).root_dir)
    return vim.lsp.rpc.start({ cmd, "--lsp" }, dispatchers)
  end,
  filetypes = {
    "css",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "scss",
    "typescript",
    "typescriptreact",
  },
  root_dir = util.root_dir_if_executable({
    "package.json",
    ".git",
  }, "oxfmt"),
  single_file_support = true,
}

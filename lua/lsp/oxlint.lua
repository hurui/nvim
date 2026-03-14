local util = require("config.lsp_util")

return {
  cmd = function(dispatchers, config)
    local cmd = util.resolve_executable("oxlint", (config or {}).root_dir)
    return vim.lsp.rpc.start({ cmd, "--lsp" }, dispatchers)
  end,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_dir = util.root_dir_if_executable({
    "oxlint.json",
    ".oxlintrc.json",
    "package.json",
    ".git",
  }, "oxlint"),
  single_file_support = true,
}

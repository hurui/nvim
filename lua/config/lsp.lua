local util = require("config.lsp_util")

vim.lsp.config.oxlint = require("lsp.oxlint")
vim.lsp.config.oxfmt = require("lsp.oxfmt")

vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    source = "if_many",
  },
  float = {
    border = "rounded",
    source = "always",
  },
  severity_sort = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})

local attach_group = vim.api.nvim_create_augroup("local_lsp_attach", { clear = true })
local format_group = vim.api.nvim_create_augroup("local_lsp_format", { clear = true })

local function map(bufnr, mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = attach_group,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if vim.lsp.completion and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end

    if vim.lsp.inlay_hint and client:supports_method("textDocument/inlayHint") then
      pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
    end

    map(bufnr, "n", "gd", vim.lsp.buf.definition, "Goto definition")
    map(bufnr, "n", "grr", vim.lsp.buf.references, "Goto references")
    map(bufnr, "n", "gri", vim.lsp.buf.implementation, "Goto implementation")
    map(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map(bufnr, "n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map(bufnr, "n", "<leader>f", function()
      vim.lsp.buf.format({ bufnr = bufnr })
    end, "Format buffer")
    map(bufnr, "n", "gl", vim.diagnostic.open_float, "Line diagnostics")

    if client.name == "oxfmt" and client:supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            id = client.id,
            timeout_ms = 3000,
          })
        end,
      })
    end
  end,
})

local servers = { "ts_ls", "tailwindcss", "oxlint", "oxfmt" }
for _, server in ipairs(servers) do
  local ok, err = pcall(vim.lsp.enable, server)
  if not ok then
    vim.schedule(function()
      vim.notify(("LSP 配置 %s 不可用: %s"):format(server, err), vim.log.levels.WARN)
    end)
  end
end

return {
  root_dir = util.root_dir,
}

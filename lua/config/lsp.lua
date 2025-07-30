local lspconfig = require('lspconfig')
local util = require('lspconfig/util')

-- Enable inlay hints for rust_analyzer
lspconfig.rust_analyzer.setup({
  on_attach = function(client, bufnr)
    -- Enable inlay hints
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
  settings = {
    ['rust-analyzer'] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true
      },
      -- Enable inlay hints
      inlayHints = {
        bindingModeHints = {
          enable = false,
        },
        chainingHints = {
          enable = true,
        },
        closingBraceHints = {
          enable = true,
          minLines = 25,
        },
        closureReturnTypeHints = {
          enable = "never",
        },
        lifetimeElisionHints = {
          enable = "never",
          useParameterNames = false,
        },
        parameterHints = {
          enable = true,
        },
        rangeExclusiveHints = {
          enable = false,
        },
        typeHints = {
          enable = true,
          hideClosureInitialization = false,
          hideNamedConstructor = false,
        },
      },
    },
  },
})
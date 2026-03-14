local util = require("config.lsp_util")

local project_markers = {
  "tsconfig.json",
  "jsconfig.json",
  "package.json",
}

local fallback_markers = {
  ".git",
}

local hints = {
  includeInlayEnumMemberValueHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayVariableTypeHintsWhenTypeMatchesName = false,
}

return {
  cmd = { "typescript-language-server", "--stdio" },
  root_dir = function(bufnr, on_dir)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == "" then
      on_dir(vim.uv.cwd())
      return
    end

    local root = util.find_upward_root(name, project_markers)
      or util.find_upward_root(name, fallback_markers)
      or vim.uv.cwd()

    on_dir(root)
  end,
  init_options = {
    hostInfo = "neovim",
    preferences = {
      includeCompletionsForImportStatements = true,
      includeCompletionsForModuleExports = true,
      includePackageJsonAutoImports = "auto",
    },
  },
  settings = {
    typescript = {
      inlayHints = hints,
    },
    javascript = {
      inlayHints = hints,
    },
  },
  on_attach = function(client)
    util.disable_formatting(client)
    util.maybe_warn_missing_typescript(client.config.root_dir)
  end,
  on_new_config = function(new_config, root_dir)
    new_config.cmd = util.resolve_cmd("typescript-language-server", { "--stdio" }, root_dir)

    local tsdk = util.find_typescript_lib(root_dir)
    if tsdk then
      new_config.init_options = vim.tbl_deep_extend("force", new_config.init_options or {}, {
        typescript = {
          tsdk = tsdk,
        },
      })
    end
  end,
}

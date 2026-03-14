local M = {}

local uv = vim.uv

local warned_roots = {}

local function is_executable(path)
  return type(path) == "string" and path ~= "" and vim.fn.executable(path) == 1
end

function M.root_dir(bufnr, markers)
  local name = vim.api.nvim_buf_get_name(bufnr or 0)
  if name == "" then
    name = uv.cwd()
  end

  return vim.fs.root(name, markers) or uv.cwd()
end

function M.find_upward_root(start_path, markers)
  local path = start_path ~= "" and start_path or uv.cwd()
  local dir = vim.fn.fnamemodify(path, ":p:h")

  if vim.fn.isdirectory(path) == 1 then
    dir = vim.fn.fnamemodify(path, ":p")
  end

  local function has_marker(base)
    for _, marker in ipairs(markers) do
      local candidate = vim.fs.joinpath(base, marker)
      if uv.fs_stat(candidate) then
        return true
      end
    end
    return false
  end

  if has_marker(dir) then
    return dir
  end

  for parent in vim.fs.parents(dir) do
    if has_marker(parent) then
      return parent
    end
  end

  return nil
end

function M.find_executable(bin, root_dir)
  local candidates = {}

  if root_dir and root_dir ~= "" then
    table.insert(candidates, vim.fs.joinpath(root_dir, "node_modules", ".bin", bin))
    table.insert(candidates, vim.fs.joinpath(root_dir, bin))
  end

  local cwd = uv.cwd()
  if cwd and cwd ~= root_dir then
    table.insert(candidates, vim.fs.joinpath(cwd, "node_modules", ".bin", bin))
    table.insert(candidates, vim.fs.joinpath(cwd, bin))
  end

  for _, candidate in ipairs(candidates) do
    if is_executable(candidate) then
      return candidate
    end
  end

  local global = vim.fn.exepath(bin)
  if global ~= "" then
    return global
  end

  return nil
end

function M.resolve_executable(bin, root_dir)
  return M.find_executable(bin, root_dir) or bin
end

function M.resolve_cmd(bin, args, root_dir)
  local cmd = { M.resolve_executable(bin, root_dir) }
  vim.list_extend(cmd, args or {})
  return cmd
end

function M.find_typescript_lib(start_path)
  local root = M.find_upward_root(start_path, { "node_modules" })
  if not root then
    return nil
  end

  local tsdk = vim.fs.joinpath(root, "node_modules", "typescript", "lib")
  if uv.fs_stat(tsdk) then
    return tsdk
  end

  return nil
end

function M.root_dir_if_executable(markers, bin)
  return function(bufnr, on_dir)
    local root = M.root_dir(bufnr, markers)
    if M.find_executable(bin, root) then
      on_dir(root)
    end
  end
end

function M.disable_formatting(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

function M.maybe_warn_missing_typescript(root_dir)
  if not root_dir or warned_roots[root_dir] then
    return
  end

  local tsdk = M.find_typescript_lib(root_dir)
  if tsdk and uv.fs_stat(vim.fs.joinpath(tsdk, "tsserverlibrary.js")) then
    return
  end

  warned_roots[root_dir] = true

  vim.schedule(function()
    vim.notify(
      ("项目 %s 未检测到本地 typescript，将回退到全局 TypeScript 解析。"):format(root_dir),
      vim.log.levels.WARN
    )
  end)
end

return M

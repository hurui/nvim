# Neovim 最小 TypeScript/Tailwind/OXC 配置

这是一套基于 Neovim `0.11.5+` 新 LSP 接口的极简配置，目标是只依赖 `nvim-lspconfig`，完成 TypeScript、Tailwind 和 OXC 的日常开发闭环。

## 特性

- 使用 `vim.lsp.config()`、`vim.lsp.enable()`、`vim.lsp.completion.enable()`
- 不使用 `lazy.nvim`、`mason.nvim`、`nvim-cmp`、`null-ls`
- `ts_ls` 负责 TypeScript/JavaScript 语义能力
- `tailwindcss` 负责 Tailwind 类名补全、hover、诊断
- `oxlint` 负责 lint 诊断和 quick fix
- `oxfmt` 负责格式化
- 优先使用项目本地二进制，找不到再回退到全局 PATH

## 要求

- Neovim `0.11.5+`
- 已安装 Node 环境
- 可访问 GitHub 以安装 `nvim-lspconfig`

## 安装

### 1. 安装 `nvim-lspconfig`

在本配置目录执行：

```sh
./scripts/install_nvim_lspconfig.sh
```

安装后，插件会位于：

```text
pack/vendor/start/nvim-lspconfig
```

### 2. 安装全局语言服务器

至少需要：

```sh
npm install -g typescript typescript-language-server
npm install -g @tailwindcss/language-server
```

如果你要启用 OXC lint 和格式化，再安装：

```sh
npm install -g oxlint oxfmt
```

## 项目内依赖建议

虽然支持全局回退，但仍建议在项目内安装：

```sh
pnpm add -D typescript tailwindcss oxlint oxfmt
```

原因是这套配置会优先解析项目本地版本，避免不同项目共用全局版本导致行为漂移。

## 使用方式

进入项目后直接打开文件：

```sh
cd your-project
nvim src/index.ts
```

LSP 会按项目根自动附着。当前默认支持的主要场景：

- `*.ts` `*.tsx` `*.js` `*.jsx`
- `html` `css`
- 常见 Tailwind 场景，包括 `clsx`、`cn`、`cva`、`tw`

## 常用键位

- `gd` 跳转到定义
- `grr` 查看引用
- `gri` 查看实现
- `<leader>rn` 重命名
- `<leader>ca` code action
- `<leader>f` 手动格式化
- `gl` 查看当前行诊断
- `[d` 跳到上一个诊断
- `]d` 跳到下一个诊断
- `<leader>e` 打开当前行诊断浮窗

## 默认行为

- 补全使用 Neovim 内置 LSP completion 自动触发
- `ts_ls` 和 `tailwindcss` 不提供格式化，避免和 `oxfmt` 冲突
- `oxfmt` 仅在命令存在时启用，并在保存时自动格式化
- `oxlint` 仅在命令存在时启用
- 如果项目内没有本地 `typescript`，会提示回退到全局 TypeScript 解析

## 目录结构

```text
init.lua
lua/config/options.lua
lua/config/keymaps.lua
lua/config/lsp.lua
lua/config/lsp_util.lua
after/lsp/ts_ls.lua
after/lsp/tailwindcss.lua
lua/lsp/oxlint.lua
lua/lsp/oxfmt.lua
scripts/install_nvim_lspconfig.sh
```

## 排查

检查 LSP 健康状态：

```vim
:checkhealth vim.lsp
```

查看当前缓冲区 LSP：

```vim
:LspInfo
```

查看当前缓冲区已附着 client：

```vim
:lua =vim.lsp.get_clients({ bufnr = 0 })
```

如果 `ts_ls` 没有启动，优先检查：

- `typescript-language-server` 是否在 PATH
- 项目根是否有 `tsconfig.json`、`jsconfig.json`、`package.json` 或 `.git`

如果 `tailwindcss` 没有启动，优先检查：

- `tailwindcss-language-server` 是否在 PATH
- 文件类型是否属于 `html`、`css`、`javascriptreact`、`typescriptreact` 等支持列表

如果保存时没有自动格式化，优先检查：

- `oxfmt` 是否在 PATH
- 当前文件类型是否属于 `javascript`、`typescript`、`json`、`css`、`html` 等支持列表

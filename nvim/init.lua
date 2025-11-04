vim.o.number = true
vim.opt.relativenumber = true
vim.o.wrap = false
vim.o.cursorline = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.hlsearch = false
vim.o.signcolumn = 'yes'

-- vim.cmd.colorscheme('retrobox')
vim.cmd.colorscheme('gruvbox')

-- Catppuccin theme
-- vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
-- require("catppuccin").setup()
-- vim.cmd.colorscheme("catppuccin")

vim.keymap.set({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set({ 'n', 'x' }, 'gp', '"+p', { desc = 'Paste clipboard text' })

vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', '<cmd>quitall<cr>', { desc = 'Exit vim' })
vim.keymap.set('n', '<leader>bd', ':bnext | bdelete#<CR>', { desc = 'Close buffer but keep window' })

require('mini.files').setup({})
vim.keymap.set('n', '<leader>e', '<cmd>lua MiniFiles.open()<cr>', { desc = 'File explorer' })
require('mini.icons').setup({ style = 'ascii' })

require('mini.pick').setup({})
vim.keymap.set('n', '<leader><space>', '<cmd>Pick buffers<cr>', { desc = 'Search open files' })
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', { desc = 'Search all files' })
vim.keymap.set('n', '<leader>fh', '<cmd>Pick help<cr>', { desc = 'Search help tags' })

require('mini.snippets').setup({})
require('mini.completion').setup({})

-- Setup LSP keymaps when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end
})

-- QML LS
vim.lsp.config("qmlls", {
  cmd = { "/opt/Qt/6.5.7/gcc_64/bin/qmlls" },
  filetypes = { "qml", "javascript" },
  root_markers = { "CMakeLists.txt", ".git" },
  settings = {
    QMLLS = {
      importPaths = {
        "/opt/Qt/6.5.7/gcc_64/qml",
        "/opt/Qt/6.5.7/gcc_64/qml/QtQuick",
        "/opt/Qt/6.5.7/gcc_64/qml/Qt",
      },
      docDir = "/opt/Qt/Docs/Qt-6.5.7",
      noCmakeCalls = true,
    },
  },
})

vim.lsp.enable({ "qmlls" })

-- Clangd config
vim.lsp.config("clangd", {
  cmd = { "clangd", "--clang-tidy", "--fallback-style=none" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = { "compile_commands.json", ".git" },
  settings = {
    clangd = {
      fallbackFlags = {
        "-std=c++20",
        "-I/opt/Qt/6.5.7/gcc_64/include/",
        "-I/opt/Qt/6.5.7/gcc_64/include/QtCore",
        "-I/opt/Qt/6.5.7/gcc_64/include/QtGui",
        "-I/opt/Qt/6.5.7/gcc_64/include/QtWidgets",
      }
    }
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
  end
})

vim.lsp.enable({ "clangd" })

vim.lsp.config('tsserver', {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  root_markers = { "package.json", "tsconfig.json", ".git" },
})

vim.lsp.enable({ 'gopls', 'angularls', 'tsserver' })

-- Utility: format the current buffer with Prettier CLI
local function prettier_format()
  local filepath = vim.fn.expand("%:p")

  local prettier = vim.fn.executable("./node_modules/.bin/prettier") == 1
      and "./node_modules/.bin/prettier"
      or "npx prettier"

  local cmd = prettier .. " --write " .. vim.fn.shellescape(filepath)
  local res = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("Prettier failed: " .. res, vim.log.levels.ERROR)
  else
    vim.cmd("silent! edit!")
    vim.notify("Prettier formatted " .. filepath)
  end
end

vim.lsp.enable({ "lua_ls" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
      return
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = ev.buf,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end,
})

vim.api.nvim_create_user_command("Prettier", prettier_format, {})
vim.keymap.set("n", "<leader>p", "<cmd>Prettier<CR>", { desc = "Format with Prettier" })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.css", "*.html", "*.md" },
  callback = prettier_format,
})

require("ibl").setup({
  indent = { char = "│" },
  scope = { enabled = true },
})

vim.g.codeium_no_map_tab = 1
require("codeium").setup({
  enable_chat = true,
})

local cmp = require("cmp")

cmp.setup({
  sources = {
    { name = "codeium" },
    { name = "nvim_lsp" },
    { name = "buffer" },
  },
  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
})

vim.keymap.set('n', '<leader>ca', '<cmd>Codeium Auth<cr>', { desc = 'Codeium Auth' })
vim.keymap.set('n', '<leader>cs', '<cmd>Codeium Status<cr>', { desc = 'Codeium Status' })
vim.keymap.set("i", "<C-l>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true })

require("toggleterm").setup({
  open_mapping = [[<c-\>]],
  direction = "float",
})

vim.keymap.set("n", "<leader>lg", function()
  require("toggleterm.terminal").Terminal
      :new({ cmd = "lazygit", hidden = true, direction = "float" })
      :toggle()
end, { desc = "Open LazyGit" })

local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
  vim.notify("Gitsigns not found", vim.log.levels.WARN)
  return
end

gitsigns.setup({
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "│" },
    untracked = { text = "│" },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 200,
  },
  preview_config = {
    border = "rounded",
  },
})

require("user.build")
vim.keymap.set("n", "<leader>bu", ":Build<CR>", { desc = "Build project" })
vim.keymap.set("n", "<leader>cl", ":Clean<CR>", { desc = "Clean project" })
vim.keymap.set("n", "<leader>eol", ":RunEol<CR>", { desc = "Run EOL app" })
vim.keymap.set("n", "<leader>hmi", ":RunCphmi<CR>", { desc = "Run CPHMI app" })
vim.keymap.set("n", "<leader>fb", ":FirstBuild<CR>", { desc = "First cmake build" })
vim.keymap.set("n", "<leader>fs", ":FirstBuildSelect<CR>", { desc = "Select platform & FirstBuild" })
vim.keymap.set("n", "<leader>br", ":BuildRunCphmi<CR>", { desc = "Build and Run CPHMI" })


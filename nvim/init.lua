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

vim.cmd.colorscheme('retrobox')
-- Catppuccin theme
-- vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
-- require("catppuccin").setup()
-- vim.cmd.colorscheme("catppuccin")


vim.keymap.set({'n', 'x'}, 'gy', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set({'n', 'x'}, 'gp', '"+p', {desc = 'Paste clipboard text'})

vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save file'})
vim.keymap.set('n', '<leader>q', '<cmd>quitall<cr>', {desc = 'Exit vim'})
vim.keymap.set("n", "<leader>bd", ":bnext | bdelete#<CR>", { desc = "Close buffer but keep window" })

require('mini.files').setup({})
vim.keymap.set('n', '<leader>e', '<cmd>lua MiniFiles.open()<cr>', {desc = 'File explorer'})
require('mini.icons').setup({style = 'ascii'})

require('mini.pick').setup({})
vim.keymap.set('n', '<leader><space>', '<cmd>Pick buffers<cr>', {desc = 'Search open files'})
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', {desc = 'Search all files'})
vim.keymap.set('n', '<leader>fh', '<cmd>Pick help<cr>', {desc = 'Search help tags'})


require('mini.snippets').setup({})
require('mini.completion').setup({})

-- Setup LSP keymaps when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }

    -- Go to definition
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

    -- More useful LSP keys (optional but recommended)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end
})

-- QML Language Server - Qt 6.5.7
vim.lsp.config("qmlls", {
  cmd = { "/opt/Qt/6.5.7/gcc_64/bin/qmlls" },
  filetypes = { "qml", "javascript" },
  root_markers = { "CMakeLists.txt", "package.json", ".git" },

  settings = {
    QMLLS = {
      importPaths = {
        "/opt/Qt/6.5.7/gcc_64/qml",
        "/opt/Qt/6.5.7/gcc_64/qml/QtQuick",
        "/opt/Qt/6.5.7/gcc_64/qml/Qt",         -- general Qt modules
      },
      docDir = "/opt/Qt/Docs/Qt-6.5.7",
      noCmakeCalls = true, -- Recommended for Neovim; prevents CMake spam
    },
  },
})

-- Enable QML LS
vim.lsp.enable({ "qmlls" })

-- Qt C++ (clangd)
vim.lsp.config("clangd", {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
  root_markers = { "CMakeLists.txt", "compile_commands.json", ".git" },
  capabilities = vim.lsp.protocol.make_client_capabilities(),
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
  }
})

vim.lsp.enable({ "clangd" })

vim.lsp.config('tsserver', {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  root_markers = { "package.json", "tsconfig.json", ".git" },
})

vim.lsp.enable({'gopls', 'angularls', 'tsserver'})

-- Utility: format the current buffer with Prettier CLI
local function prettier_format()
  local filepath = vim.fn.expand("%:p")
  local cmd = { "prettier", "--write", filepath }

  -- Save any unsaved changes before formatting
  vim.cmd("write")

  local result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("Prettier failed: " .. result, vim.log.levels.ERROR)
  else
    vim.notify("Prettier formatted " .. filepath)
    -- reload the buffer after formatting
    vim.cmd("edit!")
  end
end

-- Create :Prettier command
vim.api.nvim_create_user_command("Prettier", prettier_format, {})

-- Keymap
vim.keymap.set("n", "<leader>p", "<cmd>Prettier<CR>", { desc = "Format with Prettier" })

-- Autoformat before save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.css", "*.html", "*.md" },
  callback = prettier_format,
})

-- Indent lines
require("ibl").setup {
  indent = { char = "│" },
  scope = { enabled = true },
}

-- Codeium setup
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

    -- Navigation
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

-- Codeium keymaps (optional)
vim.keymap.set('n', '<leader>ca', '<cmd>Codeium Auth<cr>', {desc = 'Codeium Auth'})
vim.keymap.set('n', '<leader>cs', '<cmd>Codeium Status<cr>', {desc = 'Codeium Status'})
vim.keymap.set("i", "<C-l>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true })


-- lspconfig
local lspconfig = require('lspconfig')
lspconfig.bashls.setup {}
lspconfig.clangd.setup {}
lspconfig.elmls.setup {}
lspconfig.gopls.setup {}
lspconfig.nixd.setup {}
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
lspconfig.zls.setup {}
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- treesitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
}

-- lualine
require('lualine').setup {
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'lsp_progress'},
    lualine_x = {},
    lualine_y = {'filetype'},
    lualine_z = {'progress', 'location'}
  }
}

-- neo-tree
require("neo-tree").setup {
  close_if_last_window = true,
  source_selector = {
    winbar = true,
    statusline = false,
    sources = {
      {
        source = "filesystem",
        display_name = "󰙅 Files",
      },
      {
        source = "buffers",
        display_name = " Buffers",
      },
      {
        source = "git_status",
        display_name = " Git"
      }
    },
  },
  use_libuv_file_watcher = true,
  follow_current_file = {
    enabled = true
  }
}
vim.keymap.set('n', '<C-b>', '<cmd>Neotree focus buffers <cr>', {silent = true})
vim.keymap.set('n', '<C-f>', '<cmd>Neotree focus filesystem <cr>', {silent = true})
vim.keymap.set('n', '<C-n>', '<cmd>Neotree focus filesystem <cr>', {silent = true})
vim.keymap.set('n', '<C-s>', '<cmd>Neotree focus git_status <cr>', {silent = true})

-- bufferline
require("bufferline").setup {}

-- orgmode
require("orgmode").setup {}

-- guess indentation settings
require('guess-indent').setup {}


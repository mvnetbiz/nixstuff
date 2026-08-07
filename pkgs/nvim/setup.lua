require('telescope').setup {
}
require('telescope').load_extension('fzf')

local t = require('telescope.builtin')

--
vim.lsp.config('verible', {
    cmd = {'verible-verilog-ls', '--rules_config_search'},
})

vim.lsp.enable({
  'bashls',
  'clangd',
  'elmls',
  'gopls',
  'nixd',
  'pyright',
  'ts_ls',
  'verible',
  'zls',
})

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

-- bufferline
require("bufferline").setup {}

-- orgmode
require("orgmode").setup {}

-- guess indentation settings
require('guess-indent').setup {}

-- aerial outline
require("aerial").setup({
  on_attach = function(bufnr)
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})

-- formatter
conform = require("conform")
conform.setup({
  formatters_by_ft = {
    python = {"black"},
  },
})

function format()
  conform.format({
    async = true,
    lsp_format = "fallback",
  },
  function(err, did_edit)
  end)
end

vim.api.nvim_create_user_command('F', format, {})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.g.mapleader = " "
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>', { desc = 'Toggle outline' })
vim.keymap.set('n', '<leader>ff', t.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', t.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fw', t.grep_string, { desc = 'Telescope grep cursor/selection' })
vim.keymap.set('n', '<leader>fb', t.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', t.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>F', format, { desc = 'Format buffer' })
vim.keymap.set('n', '<C-b>', '<cmd>Neotree focus buffers <cr>', {silent = true})
vim.keymap.set('n', '<C-f>', '<cmd>Neotree focus filesystem <cr>', {silent = true})
vim.keymap.set('n', '<C-n>', '<cmd>Neotree focus filesystem <cr>', {silent = true})
vim.keymap.set('n', '<C-s>', '<cmd>Neotree focus git_status <cr>', {silent = true})

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
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})

-- venn.nvim: enable or disable keymappings
function _G.Toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
    else
        vim.cmd[[setlocal ve=]]
        vim.api.nvim_buf_del_keymap(0, "n", "J")
        vim.api.nvim_buf_del_keymap(0, "n", "K")
        vim.api.nvim_buf_del_keymap(0, "n", "L")
        vim.api.nvim_buf_del_keymap(0, "n", "H")
        vim.api.nvim_buf_del_keymap(0, "v", "f")
        vim.b.venn_enabled = nil
    end
end
-- toggle keymappings for venn using <leader>v
vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true})

require("telescope").setup({})
require("telescope").load_extension("fzf")

local t = require("telescope.builtin")

require("lazydev").setup({})

vim.lsp.enable({
  "bashls",
  "clangd",
  "elmls",
  "lua_ls",
  "gopls",
  "nixd",
  "pyright",
  "ts_ls",
  "zls",
})

require("vim._core.ui2").enable({
  enable = true,
  msg = {
    targets = "cmd",
    cmd = { height = 0.5 },
    dialog = { height = 0.5 },
    msg = { height = 0.5, timeout = 4000 },
    pager = { height = 1 },
  },
})

-- lualine
require("lualine").setup({
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "lsp_progress" },
    lualine_x = {},
    lualine_y = { "filetype" },
    lualine_z = { "progress", "location" }
  }
})

-- neo-tree
require("neo-tree").setup({
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
})

-- bufferline
require("bufferline").setup({})

-- orgmode
require("orgmode").setup({})

-- guess indentation settings
require("guess-indent").setup({})

-- aerial outline
require("aerial").setup({
  on_attach = function(bufnr)
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})

-- formatter
local conform = require("conform")
conform.setup({
  formatters_by_ft = {
    python = { "black" },
  },
})

local function format()
  conform.format({
      async = true,
      lsp_format = "fallback",
    },
    function(err, did_edit)
    end)
end

vim.api.nvim_create_user_command("F", format, {})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle outline" })
vim.keymap.set("n", "<leader>ff", t.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", t.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fw", t.grep_string, { desc = "Telescope grep cursor/selection" })
vim.keymap.set("n", "<leader>fb", t.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", t.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>F", format, { desc = "Format buffer" })
vim.keymap.set("n", "<C-b>", "<cmd>Neotree focus buffers <cr>", { silent = true })
vim.keymap.set("n", "<C-f>", "<cmd>Neotree focus filesystem <cr>", { silent = true })
vim.keymap.set("n", "<C-n>", "<cmd>Neotree focus filesystem <cr>", { silent = true })
vim.keymap.set("n", "<C-s>", "<cmd>Neotree focus git_status <cr>", { silent = true })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  end,
})

-- venn.nvim: enable or disable keymappings
local venn = require("venn")

local function toggle_venn()
  local directions = { "h", "j", "k", "l" }
  local venn_enabled = vim.inspect(vim.b.venn_enabled)
  if venn_enabled == "nil" then
    vim.b.venn_enabled = true
    vim.opt_local.virtualedit = "all"
    -- draw a line on HJKL keystokes
    for _, key in ipairs(directions) do
      vim.keymap.set("n", string.upper(key), "<C-v>" .. key .. ":VBox<CR>", { buffer = 0 })
    end
    -- draw a box by pressing "f" with visual selection
    vim.keymap.set("v", "f", ":VBox<CR>", { buffer = 0 })
  else
    vim.opt_local.virtualedit = ""
    for _, key in ipairs(directions) do
      vim.keymap.del("n", string.upper(key), { buffer = 0 })
    end
    vim.keymap.del("v", "f", { buffer = 0 })
    vim.b.venn_enabled = nil
  end
end

-- toggle keymappings for venn using <leader>v
vim.keymap.set("n", "<leader>v", toggle_venn, { noremap = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "verilog", "systemverilog" },
  callback = function(args)
    local flagfilename = ".verible_flags"
    local bufnr = args.buf

    local root_dir = vim.fs.root(bufnr, { ".git", flagfilename })
    if not root_dir then
      root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
    end

    local cmd = { "verible-verilog-ls", "--rules_config_search" }

    local flagfile = vim.fs.joinpath(root_dir, flagfilename)
    if vim.uv.fs_stat(flagfile) then
      table.insert(cmd, "--flagfile=" .. flagfile)
    end

    vim.lsp.start({
      name = "verible",
      cmd = cmd,
      root_dir = root_dir,
    }, { bufnr = bufnr })
  end,
})

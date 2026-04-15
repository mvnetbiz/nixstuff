{
  vimPlugins,
  wrapNeovimUnstable,
  neovim-unwrapped,
  bash-language-server,
  fd,
  nixd,
  nixfmt,
  shellcheck,
}:
(wrapNeovimUnstable neovim-unwrapped {
  vimAlias = true;
  plugins = with vimPlugins; [
    aerial-nvim
    bufferline-nvim
    conform-nvim
    gruvbox-nvim
    gruvbox-material
    guess-indent-nvim
    lualine-lsp-progress
    lualine-nvim
    neo-tree-nvim
    nvim-lspconfig
    nvim-web-devicons
    orgmode
    plenary-nvim
    sonokai
    telescope-fzf-native-nvim
    telescope-nvim
    vim-nftables
    vim-signify
  ];
  luaRcContent = builtins.readFile ./setup.lua;
  neovimRcContent = builtins.readFile ./setup.vim;
}).overrideAttrs
  (old: {
    runtimeDeps = old.runtimeDeps ++ [
      bash-language-server
      fd
      nixd
      nixfmt
      shellcheck
    ];
  })

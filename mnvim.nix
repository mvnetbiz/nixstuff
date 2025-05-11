{ lib
, pkgs
, neovimUtils
, vimPlugins
, wrapNeovimUnstable
, neovim-unwrapped
, bash-language-server
, clang-tools
, gopls
, nixd
, nixfmt-rfc-style
, nodePackages
, pyright
, shellcheck
, zig
, zls
}:
let
  conf = neovimUtils.makeNeovimConfig {
    vimAlias = true;
    withPython3 = false;
    withRuby = false;
    withNodeJs = false;
    plugins = with vimPlugins; [
      bufferline-nvim
      guess-indent-nvim
      lualine-lsp-progress
      lualine-nvim
      neo-tree-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      orgmode
      plenary-nvim
      vim-nftables
      vim-signify
    ];
    luaRcContent = ''
      dofile('${./setup.lua}')
    '';
    customRC = builtins.readFile ./setup.vim;
  };
  extraPackages = [
    bash-language-server
    clang-tools
    gopls
    nixd
    nixfmt-rfc-style
    nodePackages.typescript-language-server
    pyright
    shellcheck
    pkgs.verible
    zig
    zls
  ];
  extraMakeWrapperArgs = lib.optionalString (extraPackages != [ ])
    ''--suffix PATH : "${lib.makeBinPath extraPackages}"'';
in
wrapNeovimUnstable neovim-unwrapped
  (conf // {
    wrapperArgs = (lib.escapeShellArgs conf.wrapperArgs) + " " + extraMakeWrapperArgs;
  })

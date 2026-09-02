{
  stdenv,
  fetchFromGitHub,
  vimPlugins,
  wrapNeovimUnstable,
  neovim-unwrapped,
  bash-language-server,
  fd,
  lua-language-server,
  nixd,
  nixfmt,
  shellcheck,
}:
let
  bark = stdenv.mkDerivation {
    name = "bark";
    src = fetchFromGitHub {
      owner = "if-not-nil";
      repo = "bark";
      rev = "be14cfb2266eca1acddc495c200a0c6c1ac039b1";
      hash = "sha256-10HGh8ashc0f02Gv3/Jf+vVq9QteXxSK01hbOjW9Mrc=";
    };
    phases = [
      "unpackPhase"
      "installPhase"
    ];
    installPhase = ''
      install -Dm644 bark.vim $out/colors/bark.vim
    '';
  };
in
(wrapNeovimUnstable neovim-unwrapped {
  vimAlias = true;
  plugins = with vimPlugins; [
    aerial-nvim
    bark
    bufferline-nvim
    conform-nvim
    gruvbox-nvim
    gruvbox-material
    guess-indent-nvim
    lazydev-nvim
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
    venn-nvim
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
      lua-language-server
      nixd
      nixfmt
      shellcheck
    ];
  })

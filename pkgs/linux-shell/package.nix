{
  linux_latest,
  linux ? linux_latest,
  ncurses,
  pkg-config,
}:

linux.overrideAttrs (old: {
  nativeBuildInputs = old.nativeBuildInputs ++ [
    ncurses
    pkg-config
  ];
})

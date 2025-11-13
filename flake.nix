{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs =
    inputs@{ nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      overlay = import ./overlay.nix inputs;
      pkgs = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [
            overlay
          ];
        }
      );
    in
    {
      packages = lib.genAttrs systems (
        system: (lib.filterAttrs (n: v: lib.isDerivation v)) pkgs.${system}.myPkgs
      );
      legacyPackages = pkgs;
    };
}

inputs: final: prev:

let
  newScope = extra: prev.lib.callPackageWith (prev // extra);
in

{
  myPkgs = final.lib.makeScope newScope (
    myPkgsPrev:
    let
      pkgs = final;
      inherit (final) lib;
    in
    {
      default = final.myPkgs.nvim;
    }
    // (lib.mapAttrs # /
      (n: v: pkgs.callPackage (./. + "/pkgs/${n}/package.nix") { })
      (builtins.readDir ./pkgs)
    )
  );

}

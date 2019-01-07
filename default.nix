{ nixpkgsPath ? null
, compiler ? "default"
}:
let
  pkgPath = if nixpkgsPath == null
    then import ./nix/nixpkgs.nix
    else nixpkgsPath;

  waarg         = import ./nix/waargonaut.nix;
  waarg-overlay = import "${waarg}/waargonaut-deps.nix";
  waarg-pkg     = import "${waarg}/waargonaut.nix";

  pkgs = import pkgPath {
    overlays = [
      waarg-overlay

      (self: super: {
        haskellPackages = super.haskellPackages.override (old: {
          overrides = self.lib.composeExtensions (old.overrides or (_: _: {})) (hself: hsuper: {
            waargonaut = hself.callPackage waarg-pkg {};
          });
        });
      })
    ];
  };

  haskellPackages = if compiler == "default"
    then pkgs.haskellPackages
    else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage ./servant-waargonaut.nix {};
in
  drv

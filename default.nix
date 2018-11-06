{ nixpkgs ? import ./nix/nixpkgs.nix
, compiler ? "default"
}:
let
  # Can't use overlays as there is a infinite recursion in the list of
  # dependencies that needs to be fixed first.
  inherit (nixpkgs) pkgs;

  haskellPackages = if compiler == "default"
    then pkgs.haskellPackages
    else pkgs.haskell.packages.${compiler};

  overrides = import ./servant-waargonaut-overrides.nix;

  modifiedHaskellPackages = haskellPackages.override (old: {
    overrides = pkgs.lib.composeExtensions
      (old.overrides or (_: _: {}))
      (overrides pkgs)
      ;
  });

  drv = modifiedHaskellPackages.callPackage ./servant-waargonaut.nix {};
in
  drv

{ nixpkgs ? import <nixpkgs> {}
, compiler ? "default"
}:
let
  # Can't use overlays as there is a infinite recursion in the list of
  # dependencies that needs to be fixed first.
  inherit (nixpkgs) pkgs;

  haskellPackages = if compiler == "default"
    then pkgs.haskellPackages
    else pkgs.haskell.packages.${compiler};

  modifiedHaskellPackages = haskellPackages.override (old: {
    overrides = pkgs.lib.composeExtensions
      (old.overrides or (_: _: {}))
      (self: super: {
        waargonaut = self.callPackage ../waargonaut { bench = false; };
      });
  });

  drv = modifiedHaskellPackages.callPackage ./servant-waargonaut.nix {};
in
  drv

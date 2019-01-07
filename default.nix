{ nixpkgsPath ? (import ./nix/nixpkgs.nix)
, compiler ? "default"
}:
let
  waarg         = import ./nix/waargonaut.nix;
  waarg-overlay = import "${waarg}/waargonaut-deps.nix";

  pkgs = import nixpkgsPath {
    overlays = [
      # Include waargonaut dependencies.
      waarg-overlay
      # Ensure we're using the pinned version of waargonaut.
      (import ./servant-waargonaut-deps.nix)
    ];
  };

  haskellPackages = if compiler == "default"
    then pkgs.haskellPackages
    else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage ./servant-waargonaut.nix {};
in
  drv

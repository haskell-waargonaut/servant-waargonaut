{ nixpkgsPath ? (import ./nix/nixpkgs.nix)
, compiler ? "default"
}:
(import ./default.nix { inherit nixpkgsPath compiler; }).env

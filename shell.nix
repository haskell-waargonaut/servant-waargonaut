{ nixpkgsPath ? null
, compiler ? "default"
}:
(import ./default.nix { inherit nixpkgsPath compiler; }).env

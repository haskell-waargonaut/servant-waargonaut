pkgs: (self: super:
let
  sources = {
    waargonaut-src = import ./nix/waargonaut.nix;
  };
  w-deps = import "${sources.waargonaut-src}/waargonaut-deps.nix";
in
(w-deps pkgs self super) // {
  waargonaut = self.callPackage sources.waargonaut-src {};
})

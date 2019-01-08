self: super:
let
  waarg         = import ./nix/waargonaut.nix;
  waarg-pkg     = import "${waarg}/waargonaut.nix";
  tasty-wai-pkg = import ./nix/tasty-wai.nix;
in
{
  haskellPackages = super.haskellPackages.override (old: {
    overrides = self.lib.composeExtensions (old.overrides or (_: _: {})) (hself: hsuper: {
      waargonaut = hself.callPackage waarg-pkg {};
      tasty-wai  = hself.callCabal2nix "tasty-wai" tasty-wai-pkg {};
    });
  });
}

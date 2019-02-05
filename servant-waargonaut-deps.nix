self: super:
let
  waarg              = import ./nix/waargonaut.nix;
  waarg-pkg          = import "${waarg}/waargonaut.nix";
  tasty-wai-pkg      = import ./nix/tasty-wai.nix;
in
{
  haskellPackages = super.haskellPackages.override (old: {
    overrides = self.lib.composeExtensions (old.overrides or (_: _: {})) (hself: hsuper: {

      # 0.3.2.1 tests don't build with generics-sop > 0.4
      uri-bytestring = self.haskell.lib.dontCheck hsuper.uri-bytestring;

      waargonaut = hself.callPackage waarg-pkg {};
      tasty-wai  = hself.callCabal2nix "tasty-wai" tasty-wai-pkg {};
    });
  });
}

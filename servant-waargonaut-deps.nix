self: super:
let
  waarg     = import ./nix/waargonaut.nix;
  waarg-pkg = import "${waarg}/waargonaut.nix";
in
{
  haskellPackages = super.haskellPackages.override (old: {
    overrides = self.lib.composeExtensions (old.overrides or (_: _: {})) (hself: hsuper: {
      # Waargonaut is the only package we need to override for now.
      waargonaut = hself.callPackage waarg-pkg {};
    });
  });
}

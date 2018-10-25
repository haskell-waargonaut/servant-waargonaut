{ mkDerivation, attoparsec, base, http-media, lens, servant, stdenv
, waargonaut, wl-pprint-annotated
}:
mkDerivation {
  pname = "servant-waargonaut";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [
    attoparsec base http-media lens servant waargonaut
    wl-pprint-annotated
  ];
  description = "Servant Integration for Waargonaut JSON Package";
  license = stdenv.lib.licenses.bsd3;
}

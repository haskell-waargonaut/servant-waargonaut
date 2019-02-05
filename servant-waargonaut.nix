{ mkDerivation, attoparsec, base, bytestring, http-media
, http-types, lens, servant, servant-server, stdenv, tasty
, tasty-wai, text, transformers, waargonaut, wai
, wl-pprint-annotated
}:
mkDerivation {
  pname = "servant-waargonaut";
  version = "0.5.0.1";
  src = ./.;
  libraryHaskellDepends = [
    attoparsec base bytestring http-media lens servant text waargonaut
    wl-pprint-annotated
  ];
  testHaskellDepends = [
    base bytestring http-types servant servant-server tasty tasty-wai
    text transformers waargonaut wai
  ];
  description = "Servant Integration for Waargonaut JSON Package";
  license = stdenv.lib.licenses.bsd3;
}

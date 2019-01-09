{ mkDerivation, attoparsec, base, bytestring, hspec, hspec-wai
, http-media, http-types, lens, servant, servant-server, stdenv
, text, transformers, waargonaut, wai, wai-extra, warp
, wl-pprint-annotated
}:
mkDerivation {
  pname = "servant-waargonaut";
  version = "0.5.0.0";
  src = ./.;
  libraryHaskellDepends = [
    attoparsec base bytestring http-media lens servant text waargonaut
    wl-pprint-annotated
  ];
  testHaskellDepends = [
    base bytestring hspec hspec-wai http-types servant servant-server
    text transformers waargonaut wai wai-extra warp
  ];
  description = "Servant Integration for Waargonaut JSON Package";
  license = stdenv.lib.licenses.bsd3;
}

{ mkDerivation, attoparsec, base, bytestring, generics-sop, hspec
, hspec-wai, http-media, http-types, lens, servant, servant-server
, stdenv, tagged, text, transformers, waargonaut, wai, wai-extra
, warp, wl-pprint-annotated
}:
mkDerivation {
  pname = "servant-waargonaut";
  version = "0.2.0.0";
  src = ./.;
  libraryHaskellDepends = [
    attoparsec base bytestring http-media lens servant tagged text
    waargonaut wl-pprint-annotated
  ];
  testHaskellDepends = [
    base bytestring generics-sop hspec hspec-wai http-types servant
    servant-server tagged text transformers waargonaut wai wai-extra
    warp
  ];
  description = "Servant Integration for Waargonaut JSON Package";
  license = stdenv.lib.licenses.bsd3;
}

{ mkDerivation, base, bytestring, http-media, http-types, lens
, servant, servant-server, stdenv, tasty, tasty-wai, text
, transformers, waargonaut, wai, wl-pprint-annotated
}:
mkDerivation {
  pname = "servant-waargonaut";
  version = "0.6.0.0";
  src = ./.;
  libraryHaskellDepends = [
    base bytestring http-media lens servant text waargonaut
    wl-pprint-annotated
  ];
  testHaskellDepends = [
    base bytestring http-media http-types lens servant servant-server
    tasty tasty-wai text transformers waargonaut wai
    wl-pprint-annotated
  ];
  description = "Servant Integration for Waargonaut JSON Package";
  license = stdenv.lib.licenses.bsd3;
}

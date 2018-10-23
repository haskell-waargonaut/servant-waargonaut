{ mkDerivation, attoparsec, base, http-media, servant, stdenv
, waargonaut, lens
}:
mkDerivation {
  pname = "servant-waargonaut";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [
    attoparsec base http-media servant waargonaut lens
  ];
  license = stdenv.lib.licenses.unfree;
  hydraPlatforms = stdenv.lib.platforms.none;
}

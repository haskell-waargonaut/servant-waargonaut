#! /usr/bin/env nix-shell
#! nix-shell -p nix-prefetch-git -i bash
HERE=$(dirname $0)
PKG=$1
REF=$2
nix-prefetch-git "https://github.com/qfpl/$PKG" "$REF" > "$HERE/$PKG.json"

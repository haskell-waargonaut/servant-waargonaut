import (builtins.fetchGit {
  # Descriptive name to make the store path easier to identify
  name = "nixos-unstable-2018-10-10";
  url = https://github.com/nixos/nixpkgs/;
  # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-unstable`
  rev = "0a7e258012b60cbe530a756f09a4f2516786d370";
}) {}

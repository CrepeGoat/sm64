{
  version ? "us",
  compiler ? "gcc"
}:

let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs {
    # https://nixos.org/manual/nixpkgs/stable/#sec-cross-usage
    crossSystem = (import <nixpkgs/lib>).systems.examples.mips-linux-gnu;
  };
in
pkgs.callPackage ./package.nix {
  inherit version compiler;
  inherit (pkgs.buildPackages) gnumake42 python3 which coreutils;
  cc = pkgs.buildPackages.stdenv.cc;
}

{
  version ? "us",
  compiler ? "ido",
}:

let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs {
    # https://nixos.org/manual/nixpkgs/stable/#sec-cross-usage
    crossSystem = {
      config = "mips-unknown-linux-gnu";
    };
  };
in
pkgs.callPackage ./package.nix {
  inherit version compiler;
  inherit (pkgs.buildPackages)
    gnumake42
    python3
    which
    coreutils
    ;
  cc = pkgs.buildPackages.gccStdenv.cc;
}

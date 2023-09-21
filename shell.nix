{ pkgs ? import <nixpkgs> { system = "x86_64-darwin"; } }:

let
  binutils-mips64-elf = (
    import ./nix-n64-build-tools/binutils.nix {
      inherit (pkgs) lib stdenv gnumake;
      target = "mips64-elf";
    }
  );
  gcc-mips64-elf = (import ./nix-n64-build-tools/gcc-mips64-elf.nix {
    inherit (pkgs) lib stdenv gmp isl libmpc mpfr;
    inherit binutils-mips64-elf;
  });
in

pkgs.mkShell {

  # nativeBuildInputs is usually what you want -- tools you need to run
  # pulled from https://github.com/n64decomp/sm64#step-1-install-dependencies-1
  nativeBuildInputs = [
    pkgs.gnumake42 # v4.4 breaks the build!
    pkgs.coreutils
    pkgs.pkg-config

    binutils-mips64-elf
    gcc-mips64-elf
  ];

  shellHook = ''
    GMAKE_DIR=$(mktemp -d)
    MAKE_PATH=$(which make)
    ln -s $MAKE_PATH $GMAKE_DIR/gmake
    export PATH="$GMAKE_DIR:$PATH"
  '';
  # gmake VERSION=us -j8
}

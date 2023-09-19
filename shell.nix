{ pkgs ? import <nixpkgs> { system = "x86_64-darwin"; } }:

let
  binutils-mips64-elf = (
    import ./nix-n64-build-tools/binutils-mips64-elf.nix {
      inherit (pkgs) lib stdenv gnumake gcc;
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
    pkgs.which
    pkgs.python3Minimal
    pkgs.gcc13

    pkgs.gnumake42 # v4.4 breaks the build!
    pkgs.coreutils
    pkgs.pkg-config

    binutils-mips64-elf
    gcc-mips64-elf
  ];

  shellHook = ''
    NEW_PATH_DIR=$(mktemp -d)
    export PATH="$NEW_PATH_DIR:$PATH"

    MAKE_PATH=$(which make)
    ln -s $MAKE_PATH $NEW_PATH_DIR/gmake
  '';
  # gmake VERSION=us -j8
}

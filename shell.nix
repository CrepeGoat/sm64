{ pkgs ? import <nixpkgs> { system = "x86_64-darwin"; } }:
  pkgs.mkShell {
    
    # nativeBuildInputs is usually what you want -- tools you need to run
    # pulled from https://github.com/n64decomp/sm64#step-1-install-dependencies-1
    nativeBuildInputs = [
      pkgs.gnumake42 # v4.4 breaks the build!
      pkgs.coreutils
      pkgs.pkg-config

      # ? tehzz/n64-dev/mips64-elf-binutils
      # X pkgs.binutils
      (import ./binutils-mips64-elf.nix (with pkgs; {inherit lib stdenv gnumake gcc;}))
    ];

    shellHook = ''
      GMAKE_DIR=$(mktemp -d)
      MAKE_PATH=$(which make)
      ln -s $MAKE_PATH $GMAKE_DIR/gmake
      export PATH="$GMAKE_DIR:$PATH"
    '';
    # gmake VERSION=us -j8
}

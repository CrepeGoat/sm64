{ pkgs ? import <nixpkgs> { system = "x86_64-darwin"; } }:
  pkgs.mkShell {
    
    # nativeBuildInputs is usually what you want -- tools you need to run
    # pulled from https://github.com/n64decomp/sm64#step-1-install-dependencies-1
    nativeBuildInputs = [
      pkgs.gcc
      pkgs.gmp
      pkgs.isl
      pkgs.libmpc
      pkgs.mpfr
      (import ./binutils-mips64-elf.nix (with pkgs; {inherit lib stdenv gnumake gcc;}))
    ];

    shellHook = ''
      cd ./tmp
    '';
    # shellHook = ''
    #   cd ./tmp
    #   ../gcc-10.2.0/configure --disable-debug --disable-dependency-tracking --disable-silent-rules --prefix=/Users/beckerawqatty/Repos/sm64/nix-n64-build-tools/out --target=mips64-elf --with-arch=vr4300 --enable-languages=c  --without-headers  --with-newlib --with-gnu-as=mips64-elf-as --with-gnu-ld=mips64-elf-ld --enable-checking=release --enable-shared --enable-shared-libgcc --disable-decimal-float --disable-gold --disable-libatomic --disable-libgomp --disable-libitm --disable-libquadmath --disable-libquadmath-support --disable-libsanitizer --disable-libssp --disable-libunwind-exceptions --disable-libvtv --disable-multilib --disable-nls --disable-rpath --disable-static --disable-threads --disable-win32-registry --enable-lto --enable-plugin --enable-static --without-included-gettext
    #   make
    #   make install
    # '';
}

# based on https://github.com/tehzz/homebrew-n64-dev/blob/master/Formula/mips64-elf-gcc.rb

{ pkgs ? import <nixpkgs> { system = "x86_64-darwin"; }
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, gmp ? pkgs.gmp
, isl ? pkgs.isl
, libmpc ? pkgs.libmpc
, mpfr ? pkgs.mpfr
, binutils ? import ./binutils.nix { inherit target; }
, target ? "mips-linux-gnu"
,
}:

let
  config_flags = [
    "--disable-debug"
    # see https://nixos.org/manual/nixpkgs/stable/#ssec-configure-phase
    "--disable-dependency-tracking"
    "--disable-silent-rules"
    # --infodir=#{info}
    # --mandir=#{man}
    # --libdir=#{lib}/mip64-elf-gcc/#{version_suffix}
    "--target=${target}"
    "--with-arch=vr4300"
    "--enable-languages=c"
    "--without-headers"
    "--with-newlib"
    "--with-gnu-as=${target}-as"
    "--with-gnu-ld=${target}-ld"
    "--enable-checking=release"
    "--enable-shared"
    "--enable-shared-libgcc"
    "--disable-decimal-float"
    "--disable-gold"
    "--disable-libatomic"
    "--disable-libgomp"
    "--disable-libitm"
    "--disable-libquadmath"
    "--disable-libquadmath-support"
    "--disable-libsanitizer"
    "--disable-libssp"
    "--disable-libunwind-exceptions"
    "--disable-libvtv"
    "--disable-multilib"
    "--disable-nls"
    "--disable-rpath"
    # see https://nixos.org/manual/nixpkgs/stable/#ssec-configure-phase
    "--disable-static"
    "--disable-threads"
    "--disable-win32-registry"
    "--enable-lto"
    "--enable-plugin"
    "--enable-static"
    "--without-included-gettext"
  ];

in
stdenv.mkDerivation rec {
  version = "10.2.0";
  pname = "${target}-gcc";
  meta = {
    description = "GNU GCC C toolchain for the ${target} target.";
    longDescription = ''
      The GNU Compiler Collection includes front ends for C, C++, Objective-C,
      Fortran, Ada, Go, and D, as well as libraries for these languages
      (libstdc++, ...).  Compiled for the ${target} target.
    '';
    homepage = "https://gcc.gnu.org/";
    changelog = "https://gcc.gnu.org/gcc-10/changes.html";
  };

  src = (builtins.fetchTarball {
    url = "https://ftp.gnu.org/gnu/gcc/gcc-${version}/gcc-${version}.tar.xz";
    sha256 = "0l1n916az5ygp3jamrd6qj0j5kq3nfl8n79rvj94g3rj85jdpi64";
  });
  # TODO are these wrong?
  nativeBuildInputs = [ gmp isl libmpc mpfr ];
  buildInputs = [ binutils ];

  patches = [ ./gcc-10.2.0.patch ];
  # Note: needs to build from a different directory, for some reason
  preConfigure = ''
    mkdir ./_build
    cd ./_build
  '';
  configureScript = "../configure";
  configureFlags = config_flags;
  preBuild = ''
    buildFlagsArray+=(-j$NIX_BUILD_CORES)
  '';
  doCheck = true;
  checkTarget = "check";
  checkFlags = [ "-k" ];
  dontStrip = true;
}
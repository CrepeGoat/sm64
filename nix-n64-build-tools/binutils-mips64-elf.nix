{ lib
, stdenv
, gnumake
, gcc
# , gettext
# , zlib
,
}:

let
  config_flags = [
    "--disable-debug"
    "--disable-dependency-tracking"
    "--disable-silent-rules"
    "--prefix=$out"
    # "--includedir=#{include}/mip64-elf-binutils/#{version_suffix}"
    # "--infodir=#{info}/mip64-elf-binutils/#{version_suffix}"
    # "--libdir=#{lib}/mip64-elf-binutils/#{version_suffix}"
    # "--mandir=#{man}/mip64-elf-binutils/#{version_suffix}"
    "--target=mips64-elf"
    "--with-arch=vr4300"
    "--enable-64-bit-bfd"
    "--enable-plugins"
    "--enable-shared"
    "--disable-gold"
    "--disable-multilib"
    "--disable-nls"
    "--disable-rpath"
    "--disable-static"
    "--disable-werror"
  ];

in
stdenv.mkDerivation rec {
  version = "2.37";
  pname = "binutils-mips64-elf";
  meta = {
    description = "GNU binutils, compiled for the mips64-elf target.";
    longDescription = ''
      GNU binutils contains various GNU compilers, assemblers, linkers, debuggers,
      etc., plus their support routines, definitions, and documentation. Compiled
      for the mips64-elf target.
    '';
    homepage = "https://www.gnu.org/software/binutils/";
  };

  src = (builtins.fetchTarball {
    url = "https://ftp.gnu.org/gnu/binutils/binutils-${version}.tar.xz";
    sha256 = "1p6g02h5l0r5ihiaa3mnayl0njvi1yr8ybidsx7b3zvpdgqqa738";
  });
  nativeBuildInputs = [ gnumake gcc ];
  # buildInputs = [gettext zlib];
  buildPhase = ''
    CC=gcc ${src}/configure ${lib.strings.concatStringsSep " " config_flags}
    make
  '';
  # installPhase = ''
  #   make install
  # '';
}

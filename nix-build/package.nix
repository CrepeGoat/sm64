{
  # nix stdlib
  stdenv,
  lib,
  requireFile,
  # nixpkgs (build platform)
  cc,
  gnumake42,
  python3,
  which,
  coreutils,
  # parameters
  version ? "us",
  compiler ? "gcc",
}:

assert lib.assertMsg stdenv.hostPlatform.isMips ''
  The host platform must be a MIPS target (e.g., `mips-linux-gnu`).

  Consider setting the `crossSystem` parameter when importing `nixpkgs`:
  ```nix
  pkgs = import <nixpkgs> {
    crossSystem = { config = "mips-unknown-linux-gnu"; };
  };
  ```

  For more details, see
  https://nixos.org/manual/nixpkgs/stable/#sec-cross-usage
'';

let
  rom-name = "sm64.${version}.z64";
  og-rom = requireFile {
    name = rom-name;
    message = ''
      This derivation does not include all assets necessary for compiling the ROMs.
      A prior copy of the game is required to extract the assets.

      Please provide a copy of the original ROM and add it to the Nix store
      using either
        nix-store --add-fixed sha1 ${rom-name}
      or
        nix-prefetch-url --type sha1 file:///path/to/${rom-name}
    '';
    sha1 = (
      if version == "jp" then
        "8a20a5c83d6ceb0f0506cfc9fa20d8f438cafe51"
      else if version == "us" then
        "9bef1128717f958171a4afac3ed78ee2bb4e86ce"
      else if version == "eu" then
        "4ac5721683d0e0b6bbb561b58a71740845dceea9"
      else if version == "sh" then
        "3f319ae697533a255a1003d09202379d78d5a2e0"
      else if version == "cn" then
        "2e1db2780985a1f068077dc0444b685f39cd90ec"
      else
        abort "invalid version ${version}: must be one of (jp, us, eu, sh, cn)"
    );
  };

  src = ./..;
in
stdenv.mkDerivation {
  pname = "sm64-compiled";
  inherit version;

  # src = fetchFromGitHub {
  #   owner = "n64decomp";
  #   repo = "sm64";
  #   rev = "9921382a68bb0c865e5e45eb594d9c64db59b1af";
  #   hash = "sha256-exrKy3nrvahyNDDmay/K7f6uU8UHNnUb9/QxOGjQaXU=";
  # };
  inherit src;

  # pulled from https://github.com/n64decomp/sm64#step-1-install-dependencies-1
  nativeBuildInputs = [
    cc
    gnumake42 # v4.4 breaks the build!
    python3
    which
    coreutils
  ];

  dontPatch = true;
  dontConfigure = true;
  preBuild = ''
    NEW_PATH_DIR=$(mktemp -d)
    export PATH="$NEW_PATH_DIR:$PATH"

    MAKE_PATH=${gnumake42}/bin/make
    ln -s $MAKE_PATH $NEW_PATH_DIR/gmake

    NEW_SRC=$(mktemp -d)
    cp -R ${src}/ $NEW_SRC
    cp ${og-rom} $NEW_SRC/baserom.${version}.z64
  '';
  buildPhase = ''
    runHook preBuild
    gmake VERSION=${version} VERBOSE=1 COMPILER=${compiler} -j$NIX_BUILD_CORES
    runHook postBuild
  '';
  installPhase = ''
    cp $NEW_SRC/build/${version}/${rom-name} $out/${rom-name}
  '';
}

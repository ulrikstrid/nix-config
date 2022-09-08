{ pkgs
, lib
, fetchFromGitHub
, rustPlatform
, cairo
, fontconfig
, pango
, xorg
, dbus
, libusb1
, glib
, cmake
, nasm
, ninja
, pkg-config
, curl
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "legion-kb-rgb";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "4JX";
    repo = "L5P-Keyboard-RGB";
    rev = "v${version}";
    sha256 = "sha256-SpFgXW03HYfcH3+PTeHcN7vBPKkEHO1YcBVwmXQzfT0=";
  };

  cargoSha256 = "sha256-h8Z8FTpKGov5Q2q9BD6a4fV9CsujMjLsFIdizWYYdoc=";

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "tray-item-0.5.0-alpha" = "sha256-8s0hJzwg+1VDuYCeEx7cWOhnWwIOypbw3MgAvDxCCAI=";
    };
  };

  nativeBuildInputs = [
    # ninja
    cmake
    git
    curl
    pkg-config
  ];

  buildInputs = [
    nasm
    glib
    dbus
    cairo
    fontconfig
    pango
    libusb1
    xorg.libXft
    xorg.libXinerama
    xorg.libXfixes
    xorg.libXcursor
  ];

  meta = with lib; {
    description = "Cross platform software to control the lighting of the 4 zone keyboard included in the 2020 and 2021 lineup of the Lenovo Legion laptops.";
    homepage = "https://github.com/4JX/L5P-Keyboard-RGB";
    license = licenses.gpl3;
    maintainers = [ maintainers.ulrikstrid ];
  };
}

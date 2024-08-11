{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  git,
  obs-studio,
  ffmpeg,
  qtbase,
  curl,
  libaom,
  ninja,
# , nvidia-video-sdk
}:
stdenv.mkDerivation rec {
  pname = "obs-streamfx";
  version = "0.12.0b164";
  src = fetchFromGitHub {
    owner = "Xaymar";
    repo = "obs-StreamFX";
    rev = version;
    sha256 = "sha256-hxVSoX+qzqvTAhni5mAjZnsAsKeWo3wbXlRQOEoBCBA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    git
    curl
    ninja
  ];
  buildInputs = [
    obs-studio
    ffmpeg
    qtbase
    libaom
  ];

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  dontWrapQtApps = true;
}

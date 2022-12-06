{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  obs-studio,
  ffmpeg,
  libjpeg,
  libimobiledevice,
  libusbmuxd,
  libplist,
  android-tools,
}:
stdenv.mkDerivation rec {
  pname = "droidcam-obs";
  version = "1.6.0";
  src = fetchFromGitHub {
    owner = "dev47apps";
    repo = "droidcam-obs-plugin";
    rev = "ff8bc6aedcc66428ed273e44104bf498c159ff83";
    sha256 = "sha256-ZiGjjSrBFAMXSxjUkoEJmsH8IlToKWKgKhOKhq7BVJI=";
  };

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace "-Isrc/test/" "-I./src/test" \
      --replace "-Isrc/" "-I./src" \
      --replace "-I/usr/include/obs" "-I${obs-studio}/include/obs" \
      --replace "-limobiledevice" "-limobiledevice-1.0" \
      --replace "cmd.c" "cmd.cc" \
      --replace "net.c" "net.cc" \
      --replace " src/command.c" "" \
      --replace "test/main.c" "test/main.c" \
      --replace "test/adbz.c" "test/adbz.c"

    cat Makefile
    ls src/*.cc src/sys/unix/*.cc
  '';

  preBuild = ''
    mkdir ./build
  '';

  propagatedBuildInputs = [
    libjpeg
    libimobiledevice
    libimobiledevice.dev
    libusbmuxd
    libplist
    obs-studio
    ffmpeg
  ];

  checkInputs = [
    android-tools
  ];

  makeFlags = [
    "ALLOW_STATIC=no"
    "JPEG_DIR=${libjpeg.dev}"
    "JPEG_LIB=${libjpeg.out}/lib"
    "IMOBILEDEV_DIR=${libimobiledevice.out}"
    "OBS_DIR=${obs-studio}"
    "FFMPEG_DIR=${ffmpeg}"
  ];

  installPhase = ''
    mkdir -p $out/share/obs/obs-plugins/droidcam-obs
    mkdir -p $out/lib/obs-plugins
    cp build/droidcam-obs.so $out/lib/obs-plugins
    cp build/droidcam-obs.so $out/share/obs/obs-plugins/droidcam-obs
    cp -R ./data/locale $out/share/obs/obs-plugins/droidcam-obs/locale
  '';

  doCheck = false;

  meta = with lib; {
    description = "DroidCam OBS";
    homepage = "https://github.com/dev47apps/droidcam-obs-plugin";
    license = licenses.gpl2;
    maintainers = with maintainers; [ulrikstrid];
    platforms = platforms.linux;
  };
}

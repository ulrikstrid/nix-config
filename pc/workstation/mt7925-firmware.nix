{ lib, fetchgit, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  name = "mt7925-firmware";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    sparseCheckout = [
      "mediatek/mt7925"
    ];
    hash = "sha256-ItaN/X1YG0+a7PsniKxDusgLJJIagUSwP0AqSHLOkGI=";
  };

  installPhase = ''
    mkdir -p $out/lib/firmware
    mv ./mediatek/mt7925/* $out/lib/firmware
  '';
}

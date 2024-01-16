{ lib, fetchgit, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  name = "mt7925-firmware";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    sparseCheckout = [
      "mediatek/mt7925"
    ];
    deepClone = false;
    hash = "sha256-soOYwCgmwl9PxiVdnCH8eix4BSyuGh+xkO88HT/2wsI=";
  };

  installPhase = ''
    mkdir -p $out/lib/firmware/mediatek/mt7925
    cp -r ./mediatek/mt7925/ $out/lib/firmware/mediatek
  '';
}

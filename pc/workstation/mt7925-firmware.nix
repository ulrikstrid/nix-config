{ lib, fetchgit, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  name = "mt7925-firmware";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "d454c702cffb9c14f67f322be5dece04a1c07454";
    sparseCheckout = [
      "mediatek/mt7925"
    ];
    deepClone = false;
    hash = "sha256-UTHx3rMfu/hhtAEfCwx3pdgFW7LYIjU/nT/GeUJyuqY=";
  };

  installPhase = ''
    mkdir -p $out/lib/firmware/mediatek/mt7925
    cp -r ./mediatek/mt7925/ $out/lib/firmware/mediatek
  '';
}

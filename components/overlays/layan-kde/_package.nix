{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "layan-kde";
  version = "0-unstable-2025-11-27";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Layan-kde";
    rev = "a0b6a4956022276aee33309b2e07d1d0ef3db30c";
    hash = "sha256-gy3sHVoCo4q7ihFuLvQEil7t4GdrbcfatOulAy2MZ9U=";
  };

  # Same layout as upstream's install.sh, limited to look-and-feel and plasma style.
  # Aurorae, Kvantum, color schemes and wallpapers are not used.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plasma/{look-and-feel,desktoptheme}

    install_variant() {
      local name=$1 scheme=$2
      cp -r plasma/look-and-feel/com.github.vinceliuice.$name $out/share/plasma/look-and-feel
      cp -r plasma/desktoptheme/common $out/share/plasma/desktoptheme/$name
      cp -r plasma/desktoptheme/$name/. $out/share/plasma/desktoptheme/$name
      cp color-schemes/$scheme.colors $out/share/plasma/desktoptheme/$name/colors
    }
    install_variant Layan Layan
    install_variant Layan-light LayanLight

    runHook postInstall
  '';

  meta = {
    description = "Flat design theme for KDE Plasma";
    homepage = "https://github.com/vinceliuice/Layan-kde";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}

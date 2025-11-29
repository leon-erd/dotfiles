final: prev: {
  teamviewer = prev.teamviewer.overrideAttrs {
    src = prev.fetchurl {
      url = "https://dl.teamviewer.com/download/linux/version_15x/teamviewer_15.61.3_amd64.deb";
      hash = "sha256-o7Em+QRW4TebRTJS5xjcx1M6KPh1ziB1j0fvlO+RYa4=";
    };
  };

  autoraise = prev.autoraise.overrideAttrs rec {
    version = "5.5";

    src = prev.fetchFromGitHub {
      owner = "sbmpost";
      repo = "AutoRaise";
      rev = "v${version}";
      hash = "sha256-Fnlca2+XsRaCz3lQ5deQkwBqpt40wp+CfWxtRJAOGvE=";
    };

    # build with EXPERIMENTAL_FOCUS_FIRST to focusing the hovered window before actually raising it
    buildPhase = ''
      runHook preBuild
      $CXX -std=c++03 -fobjc-arc -D"NS_FORMAT_ARGUMENT(A)=" -D"SKYLIGHT_AVAILABLE=1" -DEXPERIMENTAL_FOCUS_FIRST -o AutoRaise AutoRaise.mm -framework AppKit -framework SkyLight
      bash create-app-bundle.sh
      runHook postBuild
    '';
  };

  nix-output-monitor = prev.nix-output-monitor.overrideAttrs {
    version = "2.1.8-unstable-2025-11-09";
    src = prev.fetchFromGitHub {
      owner = "maralorn";
      repo = "nix-output-monitor";
      rev = "698e6f3afdc9d68dd65d84df7b030499dbfaf84b";
      hash = "sha256-QwEVaUxvXEdx5icIZZYQQjvJO5j0+GeWtJvCJ/LZwpA=";
    };
  };

  spotify = prev.spotify.overrideAttrs (oldAttrs: {
    src =
      if (prev.stdenv.isDarwin && prev.stdenv.isAarch64) then
        prev.fetchurl {
          url = "https://web.archive.org/web/20251029235406/https://download.scdn.co/SpotifyARM64.dmg";
          hash = "sha256-0gwoptqLBJBM0qJQ+dGAZdCD6WXzDJEs0BfOxz7f2nQ=";
        }
      else
        oldAttrs.src;
  });
}

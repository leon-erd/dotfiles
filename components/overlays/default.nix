{ ... }:
{
  flake.overlays.default = final: prev: {
    autoraise = prev.autoraise.overrideAttrs {
      version = "5.6";

      src = prev.fetchFromGitHub {
        owner = "sbmpost";
        repo = "AutoRaise";
        rev = "304b05d18a8aa71dc95aa94ed80eab644bcbf701";
        hash = "sha256-QmKGptrqzv7PKNpBVZVZhkJwA5U4ir3m21Hw3Kq2FYM=";
      };

      # build with EXPERIMENTAL_FOCUS_FIRST to focusing the hovered window before actually raising it
      buildPhase = ''
        runHook preBuild
        $CXX -std=c++03 -fobjc-arc -D"NS_FORMAT_ARGUMENT(A)=" -D"SKYLIGHT_AVAILABLE=1" -DEXPERIMENTAL_FOCUS_FIRST -o AutoRaise AutoRaise.mm -framework AppKit -framework SkyLight
        bash create-app-bundle.sh
        runHook postBuild
      '';
    };
  };
}

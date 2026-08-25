{ ... }:
{
  flake.overlays.default = final: prev: {
    # Removed from nixpkgs 2026-07-22 because it depended on gtk-engine-murrine (unmaintained, GTK2-only).
    # We only need the GTK3/GTK4 CSS, which doesn't use murrine at all, so keep upstream's recipe (./layan-gtk-theme/_package.nix) and just stub out the dead dependency.
    # GTK2 apps will render unstyled with this build - that's fine, we don't have any.
    layan-gtk-theme =
      (final.callPackage ./layan-gtk-theme/_package.nix {
        gtk-engine-murrine = null;
      }).overrideAttrs
        (_old: {
          propagatedUserEnvPkgs = [ ];
        });

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

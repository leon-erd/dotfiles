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

    autoraise = (prev.autoraise.override { enableExperimentalFocusFirst = true; }).overrideAttrs rec {
      version = "5.6";

      src = prev.fetchFromGitHub {
        owner = "sbmpost";
        repo = "AutoRaise";
        rev = "v${version}";
        hash = "sha256-DQyXHZPM/5rt6Vhmyhb/ienvk0ZXzg6zbVAmUYeaOVA=";
      };
    };
  };
}

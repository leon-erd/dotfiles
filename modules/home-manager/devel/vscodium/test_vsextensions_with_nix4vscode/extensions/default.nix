with import <nixpkgs> {
  overlays = [
    (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
  ];
};

let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  };
in

rustPlatform.buildRustPackage rec {
  pname = "nix4vscode";
  version = "unstable-2024-03-18";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "06e9ed7c9dcf0e5594647bd7d1a94b0023d11b31";
    hash = "sha256-7RiMkuDO0GlzM3+oHUM/3HQBZWY5j+/9SEqCunIceYE=";
  };

  cargoHash = "sha256-LB1yOnVqeCamZSm0YNjvoeiClxuXTiIZ64D6vZ0Un8w=";

  doCheck = false;

  meta = with lib; {
    description = "A tool generate nix expression from config.toml";
    homepage = "https://github.com/nix-community/nix4vscode";
    mainProgram = "nix4vscode";
    platforms = platforms.linux;
  };

}

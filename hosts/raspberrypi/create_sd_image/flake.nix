{
  description = "Raspberry Pi 3B+ Image with Wi-Fi and SSH";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; # or your preferred release
  };

  outputs =
    { self, nixpkgs }:
    rec {
      nixosConfigurations.rpi3 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          {
            nixpkgs.config.allowUnsupportedSystem = true;
            # nixpkgs.hostPlatform.system = "aarch64-linux";
            # nixpkgs.buildPlatform.system = "x86_64-linux";

            networking.hostName = "raspberrypi";
            networking.wireless.enable = true;
            networking.wireless.networks = {
              "SSID".psk = "password";
            };

            services.openssh.enable = true;
            users.users.root.openssh.authorizedKeys.keys = [
              "insert your public key here"
            ];

            system.stateVersion = "24.11"; # adjust to your channel
          }
        ];
      };

      images.rpi3 = nixosConfigurations.rpi3.config.system.build.sdImage;
    };
}

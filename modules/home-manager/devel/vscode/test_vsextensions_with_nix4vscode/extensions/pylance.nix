{ pkgs, lib }:

let
  vscode-utils = pkgs.vscode-utils;
in
{
  "ms-python"."vscode-pylance" = vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-pylance";
    publisher = "ms-python";
    version = "2023.6.40";
    sha256 = "sha256-J5nRoQjUVKaMqs0QJFY0vzutjWZ9dH6O7FXI+ZZIaBQ=";
  };
}

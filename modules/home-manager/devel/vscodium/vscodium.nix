{
  lib,
  pkgs,
  inputs,
  userSettings,
  ...
}:

let
  # configure extensions
  vscode-extensions = inputs.nix-vscode-extensions.extensions.${pkgs.system};
  myPylance = pkgs.callPackage ./extensions/pylance.nix { };
  vscodePackage = pkgs.vscodium-fhs;
in
{
  programs.vscode = {
    enable = true;
    package = vscodePackage;
    extensions = with (vscode-extensions.forVSCodeVersion vscodePackage.version).vscode-marketplace; [
      aaron-bond.better-comments
      charliermarsh.ruff
      corker.vscode-micromamba
      github.copilot
      # github.copilot-chat # copilot-chat does not work with VSCodium :(((
      james-yu.latex-workshop
      jnoortheen.nix-ide
      k--kato.intellij-idea-keybindings
      ms-python.python
      myPylance.ms-python.vscode-pylance
      # ms-toolsai.jupyter # you have to install jupyter manually for some reason
      # ms-toolsai.jupyter-keymap
      # ms-toolsai.jupyter-renderers
      # ms-toolsai.vscode-jupyter-cell-tags
      # ms-toolsai.vscode-jupyter-slideshow
      naumovs.color-highlight
      njpwerner.autodocstring
      patbenatar.advanced-new-file
      pkief.material-icon-theme
      znck.grammarly # https://github.com/znck/grammarly/issues/170
    ];
  };

  home.activation = {
    myVscodeFiles =
      let
        vscodePath = "~/.config/VSCodium";
        targetDirectory = "${userSettings.flakeDirectory}/modules/home-manager/devel/vscodium";
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p ${vscodePath}/User
        run ln -sf ${targetDirectory}/product.json ${vscodePath}/product.json
        run ln -sf ${targetDirectory}/keybindings.json ${vscodePath}/User/keybindings.json
        run ln -sf ${targetDirectory}/settings.json ${vscodePath}/User/settings.json
      '';
  };
}

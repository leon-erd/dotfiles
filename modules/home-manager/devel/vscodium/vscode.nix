{
  lib,
  pkgs,
  userSettings,
  ...
}:

let
  vscodePackage = pkgs.vscode-fhs;
in
{
  programs.vscode = {
    enable = true;
    package = vscodePackage;
    profiles.default.extensions =
      with (pkgs.forVSCodeVersion vscodePackage.version).vscode-marketplace; [
        aaron-bond.better-comments
        charliermarsh.ruff
        corker.vscode-micromamba
        # github.copilot # install copilot manually (will fetch correct version of copilot-chat)
        # github.copilot-chat
        gruntfuggly.todo-tree
        james-yu.latex-workshop
        jnoortheen.nix-ide
        k--kato.intellij-idea-keybindings
        ms-python.python
        ms-python.vscode-pylance
        # ms-toolsai.jupyter # you have to install jupyter manually for some reason
        # ms-toolsai.jupyter-keymap
        # ms-toolsai.jupyter-renderers
        # ms-toolsai.vscode-jupyter-cell-tags
        # ms-toolsai.vscode-jupyter-slideshow
        naumovs.color-highlight
        njpwerner.autodocstring
        patbenatar.advanced-new-file
        pkief.material-icon-theme
      ];
  };

  home.packages = with pkgs; [
    nixd # language server
    nixfmt-rfc-style # formatter
  ];

  home.activation = {
    myVscodeFiles =
      let
        vscodePath = "~/.config/Code";
        targetDirectory = "${userSettings.flakeDirectory}/modules/home-manager/devel/vscodium";
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p ${vscodePath}/User
        run ln -sf ${targetDirectory}/keybindings.json ${vscodePath}/User/keybindings.json
        run ln -sf ${targetDirectory}/settings.json ${vscodePath}/User/settings.json
      '';
  };
}

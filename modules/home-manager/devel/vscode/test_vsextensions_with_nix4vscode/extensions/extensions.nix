{ pkgs, lib }:

let
  inherit (pkgs.stdenv)
    isDarwin
    isLinux
    isi686
    isx86_64
    isAarch32
    isAarch64
    ;
  vscode-utils = pkgs.vscode-utils;
  merge = lib.attrsets.recursiveUpdate;
in
merge
  (merge
    (merge
      (merge
        {
          "ms-python"."python" = vscode-utils.extensionFromVscodeMarketplace {
            name = "python";
            publisher = "ms-python";
            version = "2024.3.10742127";
            sha256 = "187x6j7300wgvcxh2lcic6ivvavsllzhq0cayqiji943pw3z3k2r";
          };
          "ms-toolsai"."jupyter-keymap" = vscode-utils.extensionFromVscodeMarketplace {
            name = "jupyter-keymap";
            publisher = "ms-toolsai";
            version = "1.1.2";
            sha256 = "02rb4r5zspicj2c7ffrr6xj6dmk0948lnl2f8f89xlfrkh2z44pl";
          };
          "ms-toolsai"."jupyter-renderers" = vscode-utils.extensionFromVscodeMarketplace {
            name = "jupyter-renderers";
            publisher = "ms-toolsai";
            version = "1.0.17";
            sha256 = "1c065s2cllf2x90i174qs2qyzywrlsjkc6agcc9qvdsb426c6r9l";
          };
          "ms-toolsai"."vscode-jupyter-cell-tags" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-jupyter-cell-tags";
            publisher = "ms-toolsai";
            version = "0.1.8";
            sha256 = "14zzr0dyr110yn53d984bk6hdn0mgva4jxvxzihvsn6lv6kg50yj";
          };
          "ms-toolsai"."vscode-jupyter-slideshow" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-jupyter-slideshow";
            publisher = "ms-toolsai";
            version = "0.1.5";
            sha256 = "1p6r5vkzvwvxif3wxqi9599vplabzig27fzzz0bx9z0awfglzyi7";
          };
          "pkief"."material-icon-theme" = vscode-utils.extensionFromVscodeMarketplace {
            name = "material-icon-theme";
            publisher = "pkief";
            version = "4.34.0";
            sha256 = "1ahshxw66436mc9jpiyfac0hinnqm3s0g3akybjrda13yd9884y7";
          };
          "github"."copilot" = vscode-utils.extensionFromVscodeMarketplace {
            name = "copilot";
            publisher = "github";
            version = "1.174.0";
            sha256 = "1id269bhgczb9m6lml6zaihglyz5l88y48xrs8v1hgqk32z30gza";
          };
          "njpwerner"."autodocstring" = vscode-utils.extensionFromVscodeMarketplace {
            name = "autodocstring";
            publisher = "njpwerner";
            version = "0.6.1";
            sha256 = "11vsvr3pggr6xn7hnljins286x6f5am48lx4x8knyg8r7dp1r39l";
          };
          "github"."copilot-chat" = vscode-utils.extensionFromVscodeMarketplace {
            name = "copilot-chat";
            publisher = "github";
            version = "0.13.2024022301";
            sha256 = "0bwg242sr1wi6dv7h8509xz499bg2vqk9p3z9jmai0vb8wn27njr";
          };
          "naumovs"."color-highlight" = vscode-utils.extensionFromVscodeMarketplace {
            name = "color-highlight";
            publisher = "naumovs";
            version = "2.8.0";
            sha256 = "14capk3b7rs105ij4pjz42zsysdfnkwfjk9lj2cawnqxa7b8ygcr";
          };
          "aaron-bond"."better-comments" = vscode-utils.extensionFromVscodeMarketplace {
            name = "better-comments";
            publisher = "aaron-bond";
            version = "3.0.2";
            sha256 = "15w1ixvp6vn9ng6mmcmv9ch0ngx8m85i1yabxdfn6zx3ypq802c5";
          };
          "james-yu"."latex-workshop" = vscode-utils.extensionFromVscodeMarketplace {
            name = "latex-workshop";
            publisher = "james-yu";
            version = "9.19.1";
            sha256 = "15k0kd12kkgsxgdr8rw3379gbgffdcxw6hb2fzsca9n32bkwym1i";
          };
          "k--kato"."intellij-idea-keybindings" = vscode-utils.extensionFromVscodeMarketplace {
            name = "intellij-idea-keybindings";
            publisher = "k--kato";
            version = "1.6.0";
            sha256 = "0sq9ga1xnnkzrvvnw54a3lqb1cy45b78v86j5mrx3g8jmqqnr03n";
          };
          "patbenatar"."advanced-new-file" = vscode-utils.extensionFromVscodeMarketplace {
            name = "advanced-new-file";
            publisher = "patbenatar";
            version = "1.2.2";
            sha256 = "09a6yldbaz9d7gn9ywkqd96l3pkc0y30b6b02nv2qigli6aihm6g";
          };
          "znck"."grammarly" = vscode-utils.extensionFromVscodeMarketplace {
            name = "grammarly";
            publisher = "znck";
            version = "0.25.0";
            sha256 = "048bahfaha3i6sz1b5jkyhfd2aiwgpkmyy2i7hlzc45g1289827z";
          };
          "jnoortheen"."nix-ide" = vscode-utils.extensionFromVscodeMarketplace {
            name = "nix-ide";
            publisher = "jnoortheen";
            version = "0.3.1";
            sha256 = "1cpfckh6zg8byi6x1llkdls24w9b0fvxx4qybi9zfcy5gc60r6nk";
          };
          "corker"."vscode-micromamba" = vscode-utils.extensionFromVscodeMarketplace {
            name = "vscode-micromamba";
            publisher = "corker";
            version = "0.1.20";
            sha256 = "0y0382wgyn1rvzgn9f8fsr34zbw3w4ynp6xll3fgz299nz9rr0gz";
          };
        }
        (
          lib.attrsets.optionalAttrs (isLinux && (isi686 || isx86_64)) {
            "ms-toolsai"."jupyter" = vscode-utils.extensionFromVscodeMarketplace {
              name = "jupyter";
              publisher = "ms-toolsai";
              version = "2024.2.2024022602";
              sha256 = "1j61qbbskq9pjxkis042k6ainmsmc2vc70wyxrk298n1a94mfqsy";
              arch = "linux-x64";
            };
            "charliermarsh"."ruff" = vscode-utils.extensionFromVscodeMarketplace {
              name = "ruff";
              publisher = "charliermarsh";
              version = "2024.16.0";
              sha256 = "1qha198h9zp95wf6fqd7zagk0pcd5vxxx4n7n1kqb29n78zk56yr";
              arch = "linux-x64";
            };
          }
        )
      )
      (
        lib.attrsets.optionalAttrs (isLinux && (isAarch32 || isAarch64)) {
          "ms-toolsai"."jupyter" = vscode-utils.extensionFromVscodeMarketplace {
            name = "jupyter";
            publisher = "ms-toolsai";
            version = "2024.2.2024022602";
            sha256 = "1709nsasjcpjcjhyvjimyz1q1sq1f3zi6276d7pxpysivpz0h4jz";
            arch = "linux-arm64";
          };
          "charliermarsh"."ruff" = vscode-utils.extensionFromVscodeMarketplace {
            name = "ruff";
            publisher = "charliermarsh";
            version = "2024.16.0";
            sha256 = "1b3zrm58zjr4v7n1gfklx6n8w2ywhgr5l1g596qpa1fab0pljkz3";
            arch = "linux-arm64";
          };
        }
      )
    )
    (
      lib.attrsets.optionalAttrs (isDarwin && (isi686 || isx86_64)) {
        "ms-toolsai"."jupyter" = vscode-utils.extensionFromVscodeMarketplace {
          name = "jupyter";
          publisher = "ms-toolsai";
          version = "2024.2.2024022602";
          sha256 = "0am5837rfzwc1j3zy01lmmd8803x498k88gyp7ibl0jqpkqk8wl1";
          arch = "darwin-x64";
        };
        "charliermarsh"."ruff" = vscode-utils.extensionFromVscodeMarketplace {
          name = "ruff";
          publisher = "charliermarsh";
          version = "2024.16.0";
          sha256 = "0cvh1bk0kb1xp3b733fn6ny0zyv5fk744yccw3kaa15gk7c05v6q";
          arch = "darwin-x64";
        };
      }
    )
  )
  (
    lib.attrsets.optionalAttrs (isDarwin && (isAarch32 || isAarch64)) {
      "ms-toolsai"."jupyter" = vscode-utils.extensionFromVscodeMarketplace {
        name = "jupyter";
        publisher = "ms-toolsai";
        version = "2024.2.2024022602";
        sha256 = "0h1l3nidzq8n3d8z5jingbdv5hckb8wg1609cmn89hyjnafwvmwy";
        arch = "darwin-arm64";
      };
      "charliermarsh"."ruff" = vscode-utils.extensionFromVscodeMarketplace {
        name = "ruff";
        publisher = "charliermarsh";
        version = "2024.16.0";
        sha256 = "042nf94k66kkhr6ydb8kx5b00v45wnly8vvpyn8z0c2lbxc74hbk";
        arch = "darwin-arm64";
      };
    }
  )

{ pkgs, ... }: {
       # Home Manager has an option to automatically set some environment
       # variables that will ease usage of software installed with nix on
       # non-NixOS linux (fixing local issues, settings XDG_DATA_DIRS, etc.):
        targets.genericLinux.enable = true;
        programs.direnv = {
          enable = true;
          enableBashIntegration = true;
          nix-direnv.enable = true;
        };
        programs.vscode = {
          enable = true;
          package = (pkgs.vscode.override{ isInsiders = true; }).overrideAttrs (oldAttrs: rec {
      src = (builtins.fetchTarball {
        url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
        sha256 = "0zb6hw5js6dff0a7rl4dzgn7za8swx4rr1zdbagm8ag5qny60nhi";
      });
      version = "latest";
    });
        };
        programs.exa = {
          enable = true;
          enableAliases = true;
        };
        programs.bash = {
          enable = true;
          enableVteIntegration = true;
          historyIgnore = [ "ls" "cd" "exit" "gopass" ];
          shellAliases = {
            cat = "bat";
            cd = "z";
          };
          bashrcExtra = ''
            source ~/.local/share/blesh/ble.sh
            PATH=$PATH:~/.volta/bin
            eval "$(github-copilot-cli alias -- "$0")"
          '';
          sessionVariables = {
            CHAMBER_KMS_KEY_ALIAS = "aws/ssm";
            BROWSER = "wsl-open";
            AWS_VAULT_PASS_PREFIX = "aws-vault";
            AWS_VAULT_BACKEND = "kwallet";
            AWS_SESSION_TOKEN_TTL = 10;
            VOLTA_HOME = "$HOME/.volta";
            USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
          };
        };
        programs.bat.enable = true;
        programs.zoxide = {
          enable = true;
          enableBashIntegration = true;
        };
        programs.atuin = {
          enable = true;
          enableBashIntegration = true;
          settings = {
            auto_sync = true;
            sync_frequency = "5m";
            sync_address = "https://api.atuin.sh";
            search_mode = "fuzzy";
          };
        };
        programs.broot = {
          enable = true;
          enableBashIntegration = true;
          settings.modal = true;
        };
        programs.jq.enable = true;
        programs.navi = {
          enable = true;
          enableBashIntegration = true;
        };
        programs.pet = { enable = true; };
        programs.password-store.enable = true;
        programs.git.enable = true;
        programs.git.extraConfig = {
          user.name = "Tao Hansen";
          user.email = "59834693+worldofgeese@users.noreply.github.com";
          credential.helper = "/mnt/c/Users/Tao\\ Hansen/scoop/apps/git-credential-manager/current/git-credential-manager.exe";
          init.defaultBranch = "main";
          core.autocrlf = "false";
          core.eol = "lf";
          gpg.format = "ssh";
          gpg."ssh".program = "/mnt/c/Users/Tao Hansen/AppData/Local/1Password/app/8/op-ssh-sign.exe";
        };
        programs.starship = {
          enable = true;
          enableBashIntegration = true;
          settings = {
            command_timeout = 1000;
            terraform = {
              format = "[$symbol$version]($style) ";
              symbol = "tf ";
            };
            character = {
              success_symbol = "[>](bold green)";
              error_symbol = "[x](bold red)";
              vicmd_symbol = "[<](bold green)";
            };
            git_commit = { tag_symbol = " tag "; };
            git_status = {
              ahead = ">";
              behind = "<";
              diverged = "<>";
              renamed = "r";
              deleted = "x";
            };
            git_branch = { symbol = "git "; };
            aws = { symbol = "aws "; };
            nodejs = { symbol = "nodejs "; };
          };
        };
        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;
        home.username = "taohansen";
        home.homeDirectory = "/home/taohansen";
        home.stateVersion = "22.11";
        home.sessionPath =
          [ "$HOME/bin" "$HOME/.local/bin" "$HOME/.garden/bin" "$HOME/.arkade/bin/" "/mnt/c/Users/Tao Hansen/AppData/Local/Programs/Microsoft VS Code/bin" "$HOME/.npm-global/bin" "$HOME/.volta/bin" ];
        xdg.systemDirs.data = [ "/usr/local/share" "/usr/share" "$HOME/.nix-profile/share" ];
        home.packages = with pkgs; [
          # # Adds the 'hello' command to your environment. It prints a friendly
          # # "Hello, world!" when run.
          # pkgs.hello
      
          # # It is sometimes useful to fine-tune packages, for example, by applying
          # # overrides. You can do that directly here, just don't forget the
          # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
          # # fonts?
          # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
      
          # # You can also create simple shell scripts directly inside your
          # # configuration. For example, this adds a command 'my-hello' to your
          # # environment:
          # (pkgs.writeShellScriptBin "my-hello" ''
          #   echo "Hello, ${config.home.username}!"
          # '')
          awscli2 # Unified tool to manage your AWS services
          rsync # A fast incremental file transfer utility
          xh # Friendly and fast tool for sending HTTP requests
          ripgrep # A utility that combines the usability of The Silver Searcher with the raw speed of grep
          croc # Easily and securely send things from one computer to another
          fzf # A command-line fuzzy finder written in Go
          cloud-nuke # A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it
          chamber # A tool for managing secrets by storing them in AWS SSM Parameter Store
          shfmt # A shell parser and formatter
          openshift
          pandoc
          kubernetes-helm
          helmfile
          wsl-open
          kubectl
          aws-vault
          arkade
          fluxcd
          k9s
          topgrade
          kompose
          scaleway-cli
          spr
          pulumi
          azure-cli
      	  krew
          civo
          operator-sdk
          python311
          kwalletmanager
          gh
          eksctl
          yq
          (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
          terraform
        ];
      home.file.".aws/config".text = ''
        [profile taohansen]
        sso_start_url=https://garden-io.awsapps.com/start
        sso_region=eu-central-1
        sso_account_id=431328314483
        sso_role_name=CommunityEngineerAccess
        region = eu-central-1
      '';
      home.file.".local/share/applications/code-insiders.desktop".text = ''
        [Desktop Entry]
        Icon=code
        Type=Application
        Name=Code - Insiders
        Exec=/home/taohansen/.nix-profile/bin/code-insiders %F
        StartupNotify=true
        StartupWMClass=Code
        
        [Desktop Action new-empty-window]
        Exec=code-insiders --new-window %F
        Icon=code
        Name=New Empty Window
      '';
}

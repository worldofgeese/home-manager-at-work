{pkgs, ...}: {
  # Home Manager has an option to automatically set some environment
  # variables that will ease usage of software installed with nix on
  # non-NixOS linux (fixing local issues, settings XDG_DATA_DIRS, etc.):
  # As already mentioned
  targets.genericLinux.enable = true;
  xdg.mime.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.vscode = {
    enable = true;
    #package = (pkgs.vscode.override{ isInsiders = true; }).overrideAttrs (oldAttrs: rec {
    #src = (builtins.fetchTarball {
    #  url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
    #  sha256 = "0zb6hw5js6dff0a7rl4dzgn7za8swx4rr1zdbagm8ag5qny60nhi";
    #  });
    #version = "latest"; });
  };
  programs.lsd = {
    enable = true;
    enableAliases = true;
  };
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    historyIgnore = ["ls" "cd" "exit" "gopass"];
    shellAliases = {
      cat = "bat";
      cd = "z";
      cursor = "/home/worldofgeese/AppImages/gearlever_cursor_aa2ec3.appimage";
      g = "garden";
      gd = "garden deploy -l3";
      code = "code --ozone-platform-hint=''";
    };
    bashrcExtra = ''
      source ~/.local/share/blesh/ble.sh
      PATH=$PATH:~/.volta/bin:~/.config/Code/User/globalStorage/ms-vscode-remote.remote-containers/cli-bin
      eval "$(dagger completion bash)"
      eval "$(github-copilot-cli alias -- "$0")"
      case $- in
        *i*) ;;
          *) return;;
      esac

      export OSH='/home/worldofgeese/.oh-my-bash'

      OSH_THEME="font"

      # Uncomment the following line to enable command auto-correction.
      ENABLE_CORRECTION="true"

      # Uncomment the following line to display red dots whilst waiting for completion.
      COMPLETION_WAITING_DOTS="true"

      # Uncomment the following line if you want to disable marking untracked files
      # under VCS as dirty. This makes repository status check for large repositories
      # much, much faster.
      DISABLE_UNTRACKED_FILES_DIRTY="true"

      # Uncomment the following line if you don't want the repository to be considered dirty
      # if there are untracked files.
      SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"

      OMB_USE_SUDO=true

      # To enable/disable display of Python virtualenv and condaenv
      OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable

      # Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
      # Custom completions may be added to ~/.oh-my-bash/custom/completions/
      # Example format: completions=(ssh git bundler gem pip pip3)
      # Add wisely, as too many completions slow down shell startup.
      completions=(
        git
        ssh
        kubectl
      )

      aliases=(
        general
      )

      plugins=(
        git
        bashmarks
        kubectl
      )

      source "$OSH"/oh-my-bash.sh

      # Preferred editor for local and remote sessions
      if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR='vim'
      else
        export EDITOR='cursor'
      fi
    '';
  };
  systemd.user.sessionVariables = {
    CHAMBER_KMS_KEY_ALIAS = "aws/ssm";
    # BROWSER = "wsl-open"; # uncomment for WSL
    AWS_VAULT_PASS_PREFIX = "aws-vault";
    AWS_VAULT_BACKEND = "kwallet";
    AWS_SESSION_TOKEN_TTL = 10;
    VOLTA_HOME = "$HOME/.volta";
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    NIXOS_OZONE_WL = "1";
    VOLTA_FEATURE_PNPM = "1";
    PATH = "$HOME/.nix-profile/bin:$PATH"; # fix Sway's PATH sourcing
    XDG_CURRENT_DESKTOP = "sway"; # fix screensharing on Sway
  };
  programs.bat.enable = true;
  programs.zoxide = {
    enable = true;
  };
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
      search_mode = "fuzzy";
    };
  };
  programs.broot = {
    enable = false;
    settings.modal = true;
  };
  programs.jq.enable = true;
  programs.navi = {
    enable = true;
  };
  programs.pet = {enable = true;};
  programs.password-store.enable = true;
  programs.gh.enable = true;
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    aliases = {
      # List available aliases
      aliases = "!git config --get-regexp alias | sed -re 's/alias\\.(\\S*)\\s(.*)$/\\1 = \\2/g'";
      # Command shortcuts
      ci = "commit";
      co = "checkout";
      st = "status";
      # Display tree-like log, because default log is a pain…
      lg = "log --graph --date=relative --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ad)%Creset'";
      # Useful when you have to update your last commit
      # with staged files without editing the commit message.
      oops = "commit --amend --no-edit";
      # Ensure that force-pushing won't lose someone else's work (only mine).
      push-with-lease = "push --force-with-lease";
      # Rebase won’t trigger hooks on each "replayed" commit.
      # This is an ugly hack that will replay each commit during rebase with the
      # standard `commit` command which will trigger hooks.
      rebase-with-hooks = "rebase -x 'git reset --soft HEAD~1 && git commit -C HEAD@{1}'";
      # List local commits that were not pushed to remote repository
      review-local = "!git lg @{push}..'";
      # Edit last commit message
      reword = "commit --amend";
      # Undo last commit but keep changed files in stage
      uncommit = "reset --soft HEAD~1";
      # Remove file(s) from Git but not from disk
      untrack = "rm --cache --";
    };
    extraConfig = {
      credential.helper = "${
        pkgs.git.override {withLibsecret = true;}
      }/bin/git-credential-libsecret";
      commit.gpgsign = "true";
      user.name = "Tao Hansen";
      user.email = "59834693+worldofgeese@users.noreply.github.com";
      init.defaultBranch = "main";
      push.autoSetupRemote = "true";
      core.autocrlf = "false";
      core.eol = "lf";
      # 1Password SSH for Linux signing starts
      gpg.format = "ssh";
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBPg7covTDtBL044ZbH+VmsCEgP7aGWAvfBncySB3hyV";
      gpg."ssh".program = "/opt/1Password/op-ssh-sign";
      pull.rebase = "true";
      rebase.autosquash = "true"; # automatically squash fixup and squash commits
      rebase.autostash = "true"; # automatically stash then unstash uncommitted work when rebasing
      fetch.prune = "true";
      diff.colorMoved = "zebra";
      # uncomment to use Git Credential Manager in  Windows Subsystem for Linux
      # credential.helper = "/mnt/c/Users/Tao\\ Hansen/scoop/apps/git-credential-manager/current/git-credential-manager.exe";
      # gpg."ssh".program = "/mnt/c/Users/Tao Hansen/AppData/Local/1Password/app/8/op-ssh-sign.exe";
      # 1Password SSH signing ends
    };
  };
  programs.ssh = {
    enable = true;
    controlPath = "~/.ssh/cm-%C";
    extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
  };
  programs.starship = {
    enable = false;
    settings = {
      kubernetes = {disabled = false;};
      nodejs = {disabled = true;};
    };
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.username = "worldofgeese";
  home.homeDirectory = "/home/worldofgeese";
  home.stateVersion = "22.11";
  home.sessionPath = ["$HOME/.garden/bin" "$HOME/.arkade/bin/" "/mnt/c/Users/Tao Hansen/AppData/Local/Programs/Microsoft VS Code/bin" "$HOME/.rd/bin" "$HOME/.local/bin"];
  home.packages = with pkgs; [
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
    kwalletmanager
    eksctl
    yq
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    terraform
    crc
    kubie
    docker-credential-helpers
    dapr-cli
    fd
    alejandra
    pre-commit
    github-desktop
    fh
    dura
    kubefirst
    mkcert
    ffmpeg
    volta
    jetbrains.pycharm-community
    grim
    slurp
    swappy
    wlsunset
    python-launcher
  ];
  home.file.".aws/config".text = ''
    [profile worldofgeese]
    sso_start_url=https://garden-io.awsapps.com/start
    sso_region=eu-central-1
    sso_account_id=431328314483
    sso_role_name=CommunityEngineerAccess
    region = eu-central-1
  '';
}

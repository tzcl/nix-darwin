{ config, pkgs, ... }: {
  # Required for backwards-compatibility
  home.stateVersion = "23.11";

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/usr/local/share/bin"
    "/usr/local/share/dotnet"
    "$HOME/scripts"
    "$HOME/.dotnet/tools"
    "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
    "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
    "/Applications/Sublime Merge.app/Contents/SharedSupport/bin"
  ];

  # Set up config files as symlinks (this requires absolute paths)
  home.file.".gitconfig".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/.gitconfig";
  home.file."scripts/clone-wt.zsh".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/scripts/clone-wt.zsh";
  home.file.".ssh/config".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/.ssh/config";
  home.file.".ssh/allowed_signers".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/.ssh/allowed_signers";
  home.file.".config/karabiner/karabiner.json".source =
    ./.config/karabiner/karabiner.json;
  home.file.".config/helix/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/helix/config.toml";
  home.file.".config/helix/languages.toml".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/helix/languages.toml";

  home.packages = with pkgs; [ nil nixfmt go shellcheck python3 yq-go ];

  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      defaultKeymap = "viins";
      syntaxHighlighting.enable = true;

      initExtra = ''
        # Make fn+delete forward delete
        bindkey "^[[3~"   delete-char
        bindkey "^[3;5~"  delete-char
        bindkey "^[[1;3C" forward-word
        bindkey "^[[1;3D" backward-word

        # Set up command line
        autoload -U edit-command-line
        zle -N edit-command-line
        bindkey '^xe' edit-command-line
        bindkey '^x^e' edit-command-line

        # Allow lazygit to change directories
        lg()
        {
          export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

          lazygit "$@"

          if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
              rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
          fi
        }

        # Separate words by punctuation
        WORDCHARS=""

        # Set title to current directory
        precmd () {
          print -Pn "\e]0;%~\a"
        }

        # Set up gh auth
        export GITHUB_TOKEN=$(gh auth token)

        zmodload zsh/zprof
      '';
      initExtraBeforeCompInit = ''
        if type brew &>/dev/null
        then
          FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
        fi
      '';

      shellAliases = {
        rokt-stage = "aws-vault exec rokt-stage -- ";
        rokt-prod = "aws-vault exec rokt-prod -- ";

        ld = "lazydocker";

        gc = "git add -A && git commit";
        gca = "git add -A && git commit --amend";

        switch = "darwin-rebuild switch --flake ~/src/nix-darwin";
      };
    };

    # TODO: home-manager apps don't get indexed by Spotlight
    # One option is to just add them to Raycast
    kitty.enable = true;
    kitty.shellIntegration.enableZshIntegration = true;
    kitty.theme = "Catppuccin-Frappe";
    kitty.font = {
      name = "Fira Code";
      size = 13.0;
    };
    kitty.settings = {
      top_bar_edge = "top";
      tab_bar_style = "slant";
      enabled_layouts = "tall";
      macos_option_as_alt = "both";
      shell = "zsh -i";
    };
    kitty.keybindings = {
      # Opening new splits
      "cmd+enter" = "launch --cwd=current --type=window";
      "cmd+shift+t" = "new_tab_with_cwd";

      # Prompt editing
      "alt+backspace" = "send_text all x17";
      "super+backspace" = "send_text all x15";
      "super+left" = "send_text all x01";
      "super+right" = "send_text all x05";
    };

    starship.enable = true;
    starship.enableZshIntegration = true;

    helix.enable = true;
    helix.defaultEditor = true;

    # Git and related utilities
    git = {
      enable = true;
      lfs.enable = true;
    };
    ssh.enable = true;
    lazygit = {
      enable = true;
      settings.git.overrideGpg = true;
    };
    gh.enable = true;
    gh-dash.enable = true;

    # Handy CLI tools
    atuin = {
      enable = true;
      enableZshIntegration = true;
      flags = [ "--disable-up-arrow" ];
    };

    awscli.enable = true;

    bat = {
      enable = true;
      config.theme = "catppuccin-frappe";
      themes.catppuccin-frappe = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };
        file = "Catppuccin-frappe.tmTheme";
      };
    };

    btop.enable = true;

    broot = {
      enable = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    ripgrep.enable = true;

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}

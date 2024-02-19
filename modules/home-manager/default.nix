{ pkgs, ... }: {
  # Required for backwards-compatibility
  home.stateVersion = "23.11";

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/usr/local/share/bin"
    "/usr/local/share/dotnet"
    "$HOME/scripts"
    "$HOME/.dotnet/tools"
    "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
  ];

  home.file = {
    ".gitconfig".source = ./home/.gitconfig;
    ".ssh" = {
      recursive = true;
      source = ./home/.ssh;
    };
    ".config" = {
      recursive = true;
      source = ./home/.config;
    };
    "scripts" = {
      recursive = true;
      source = ./home/scripts;
    };
  };

  home.packages = with pkgs; [ nil nixfmt ];

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

        # Set up command line
        autoload -U edit-command-line
        zle -N edit-command-line
        bindkey '^xe' edit-command-line
        bindkey '^x^e' edit-command-line

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
        rokt-prod = "aws-valut exec rokt-prod -- ";

        ld = "lazydocker";

        gc = "git add -A && git commit";
        gca = "git add -A && git commit --amend";
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
    };
    kitty.keybindings = {
      "cmd+enter" = "launch --cwd=current --type=window";
      "cmd+shift+t" = "new_tab_with_cwd";
    };

    starship.enable = true;
    starship.enableZshIntegration = true;

    helix.enable = true;
    helix.defaultEditor = true;

    # Git and related utilities
    git.enable = true;
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
    broot.enable = true;
    broot.enableZshIntegration = true;
    eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };
    fzf.enable = true;
    fzf.enableZshIntegration = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    awscli = { enable = true; };
  };
}

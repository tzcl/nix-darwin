{ pkgs, config, ... }: {

  home.file.".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/dotfiles/.config/starship.toml";

  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      plugins = [{
        name = "forgit";
        file = "forgit.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "wfxr";
          repo = "forgit";
          rev = "25.03.0";
          sha256 = "sha256-wYCuCxPv3HGEGaze/+an6ZprCtXu5ThsTCwaIquEy3Y=";
        };
      }];

      antidote = {
        enable = true;
        plugins = [
          "getantidote/use-omz"
          "ohmyzsh/ohmyzsh path:lib"
          "ohmyzsh/ohmyzsh path:plugins/git"
        ];
      };

      initExtra = ''
        # Make fn+delete forward delete
        bindkey "^[[3~"   delete-char
        bindkey "^[3;5~"  delete-char
        bindkey "^[[1;3C" forward-word
        bindkey "^[[1;3D" backward-word

        # Separate words by punctuation
        WORDCHARS=""

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

        switch = "darwin-rebuild switch --flake ~/src/nix-darwin";
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

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

    broot = {
      enable = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = "auto";
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

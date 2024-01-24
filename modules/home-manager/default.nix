{ pkgs, ... }: {
  # Required for backwards-compatibility
  home.stateVersion = "23.11";

  home.sessionPath = [ "/opt/homebrew/bin" ];

  # TODO: There should be a nicer way of doing this
  # TODO: Can I just recursively specify my dotfiles?
  # TODO: Also is there a way to symlink them?
  home.file.".gitconfig".source = ./.gitconfig;
  home.file.".ssh/config".source = ./.ssh/config;
  home.file.".ssh/allowed_signers".source = ./.ssh/allowed_signers;
  home.file.".aws/config".source = ./.aws/config;
  home.file.".config/karabiner/karabiner.json".source =
    ./.config/karabiner/karabiner.json;
  home.file.".config/helix/config.toml".source = ./helix/config.toml;
  home.file.".config/helix/languages.toml".source = ./helix/languages.toml;

  home.packages = with pkgs; [ nil nixfmt ];

  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      initExtra = ''
        # Make fn+delete forward delete
        bindkey "^[[3~"   delete-char
        bindkey "^[3;5~"  delete-char
        bindkey "^[[1;3C" forward-word
        bindkey "^[[1;3D" backward-word

        # Separate words by puncutation
        WORDCHARS=""

        precmd () {
          print -Pn "\e]0;%~\a"
        }
      '';

      shellAliases = {
        rokt-stage = "aws-vault exec rokt-stage -- ";
        rokt-prod = "aws-valut exec rokt-prod -- ";

        lg = "lazygit";
        ld = "lazydocker";
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
    };
    bat.enable = true;
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

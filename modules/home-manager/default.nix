{ config, pkgs, ... }: {
  imports = [ ./zsh.nix ./git.nix ./helix.nix ./kitty.nix ];

  # Required for backwards-compatibility
  home.stateVersion = "23.11";

  home.sessionPath = [
    "/opt/homebrew/bin"
    "$HOME/scripts"

    # Work
    "$HOME/.dotnet/tools"
    "/usr/local/share/bin"
    "/usr/local/share/dotnet"
    "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
    "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
    "/Applications/Sublime Merge.app/Contents/SharedSupport/bin"
  ];

  home.file.".config/karabiner/karabiner.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/dotfiles/.config/karabiner/karabiner.json";
  # Force overwrite of karabiner config
  home.file.".config/karabiner/karabiner.json".force = true;

  home.file.".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/dotfiles/.ideavimrc";

  home.packages = with pkgs; [
    go
    python310

    nil
    nixfmt
    shellcheck

    just
    go-task

    yq-go
    dive
    kubernetes-helm

    slack
    obsidian
    spotify
    wireshark
  ];

  # Work
  programs.awscli.enable = true;

  # Use direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.file.".config/direnv/direnvrc".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/dotfiles/.config/direnv/direnvrc";
}

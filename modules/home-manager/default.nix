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
    nil
    nixfmt
    go
    shellcheck
    python3
    yq-go
    kubernetes-helm
    just
    slack
    obsidian
    spotify
    dive
  ];

  # Work
  programs.awscli.enable = true;
}

{ config, ... }: {
  home.file.".config/helix/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/dotfiles/helix/config.toml";
  home.file.".config/helix/languages.toml".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/dotfiles/helix/languages.toml";

  programs.helix = {
    enable = true;
    defaultEditor = true;
  };
}

{ config, ... }: {
  # Set up config files as symlinks (this requires absolute paths)
  home.file.".gitconfig".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/dotfiles/.gitconfig";
  home.file."scripts/clone-wt.zsh".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/dotfiles/scripts/clone-wt.zsh";
  home.file.".ssh/config".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/dotfiles/.ssh/config";
  home.file.".ssh/allowed_signers".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/src/nix-darwin/modules/home-manager/dotfiles/.ssh/allowed_signers";

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };
    ssh.enable = true;
    lazygit.enable = true;
    gh.enable = true;
    gh-dash.enable = true;

    jujutsu = {
      enable = true;
      # Set up a config file if this gets more complex
      settings = {
        user = {
          name = "Toby Law";
          email = "toby.law@rokt.com";
        };
        ui.paginate = "never";
        signing = {
          sign-all = true;
          backend = "ssh";
          key = "~/.ssh/id_ed25519.pub";
        };
      };
    };
  };
}

{ pkgs, inputs, ... }: {
  imports = [ ./config.nix ./zsh.nix ./homebrew.nix ./raycast.nix ];

  users.users.toby = {
    name = "toby";
    home = "/Users/toby";
  };

  # Enable karabiner
  services.karabiner-elements.enable = true;

  # NOTE: This removes any manually-added fonts
  fonts.packages = with pkgs; [ fira-code fira-code-nerdfont ];

  # --- Nix config --- #

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Fix `error: file 'nixpkgs' was not found in the Nix search path`
  nix.settings.extra-nix-path = "nixpkgs=flake:nixpkgs";

  # Set Git commit hash for darwin-version.
  system.configurationRevision =
    inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

{ pkgs, inputs, user, ... }: {
  imports = [ ./config.nix ./zsh.nix ./homebrew.nix ./raycast.nix ];

  users.users.${user.name} = user;

  # Enable karabiner
  services.karabiner-elements.enable = true;
  # https://github.com/LnL7/nix-darwin/issues/1041
  nixpkgs.overlays = [
    (self: super: {
      karabiner-elements = super.karabiner-elements.overrideAttrs (old: {
        version = "14.13.0";

        src = super.fetchurl {
          inherit (old.src) url;
          hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
        };
      });
    })
  ];

  # NOTE: This removes any manually-added fonts
  fonts.packages = with pkgs; [ fira-code nerd-fonts.fira-code ];

  # --- Nix config --- #
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
  system.stateVersion = 6;
}

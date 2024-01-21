{
  description = "Toby's MacOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, ... }:
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs; [ nixfmt ];
        environment.pathsToLink = [ "/share/zsh" ];
        environment.variables = { EDITOR = "hx"; };

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        # Dock settings
        system.defaults.dock.autohide = true;
        system.defaults.dock.show-recents = false;

        # Set up keyboard
        system.keyboard.enableKeyMapping = true;
        system.keyboard.remapCapsLockToEscape = true;
        system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

        # Need to play with this, this feels way too fast
        system.defaults.NSGlobalDomain.InitialKeyRepeat = 25;
        system.defaults.NSGlobalDomain.KeyRepeat = 2;

        # Enable sudo authentication with Touch ID
        security.pam.enableSudoTouchIdAuth = true;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        users.users.toby.home = "/Users/toby";

        homebrew.enable = true;
        homebrew.casks = [ "google-chrome" ];
        homebrew.masApps = { "Bitwarden" = 1352778147; };

        homebrew.onActivation.cleanup = "zap";
        homebrew.global.brewfile = true;

        system.activationScripts.postUserActivation.text = ''
          # Following line should allow us to avoid a logout/login cycle
          /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
        '';
      };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Tobys-MacBook-Pro
      darwinConfigurations."Tobys-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration

          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.toby.imports = [
              ({ pkgs, ... }: {
                # Don't need to change this.
                home.stateVersion = "23.11";

                home.file.".gitconfig".text = ''
                  [user]
                  	name = Toby Law
                  	email = toby.zhi-chao.law@rokt.com
                  	signingkey = /Users/toby/.ssh/id_ed25519.pub

                  [init]
                  	defaultBranch = main

                  [url "ssh://git@github.com/"]
                  	insteadOf = https://github.com/

                  [push]
                  	autoSetupRemote = true

                  [commit]
                    gpgSign = true

                  [gpg]
                  	format = ssh

                  [gpg.ssh]
                    allowedSignersFile = "~/.ssh/allowed_signers"
                '';

                home.file.".ssh/config".text = ''
                  Host github.com
                    AddKeysToAgent yes
                    UseKeychain yes
                    IdentityFile ~/.ssh/id_ed25519
                '';

                home.file.".ssh/allowed_signers".text = "* ${builtins.readFile /Users/toby/.ssh/id_ed25519.pub}";

                programs = {
                  zsh.enable = true;
                  zsh.enableAutosuggestions = true;
                  zsh.enableCompletion = true;
                  zsh.syntaxHighlighting.enable = true;

                  # TODO: Set up fonts
                  # home-manager apps don't get indexed by Spotlight
                  kitty.enable = true;
                  kitty.shellIntegration.enableZshIntegration = true;
                  kitty.theme = "Catppuccin-Frappe";

                  # TODO: Bring in config
                  helix.enable = true;
                  helix.settings = { theme = "catppuccin-frappe"; };

                  git.enable = true;
                  ssh.enable = true;
                  lazygit.enable = true;

                  starship.enable = true;
                  starship.enableZshIntegration = true;

                  fzf.enable = true;
                  fzf.enableZshIntegration = true;
                };
              })
            ];
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Tobys-MacBook-Pro".pkgs;
    };
}

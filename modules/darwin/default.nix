{ pkgs, inputs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget

  environment.systemPackages = with pkgs; [ raycast ];
  environment.pathsToLink = [ "/share/zsh" ];
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  # TODO: Does enabling this do something weird? I don't fully understand how it works.
  # I think fonts won't be uninstalled from here unless uninstalled manually.
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [ fira-code fira-code-nerdfont ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  services.karabiner-elements.enable = true;

  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;
    loginShellInit = ''
      # Start ssh-agent
      eval $(ssh-agent)
    '';
  };

  users.users.toby = {
    name = "toby";
    home = "/Users/toby";
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    global.brewfile = true;

    taps = [ "ejoffe/tap" "derailed/k9s" "hashicorp/tap" "argoproj/tap" ];
    brews = [
      "ejoffe/tap/spr"

      # Work
      ## Utilities
      "aws-vault"
      "lazydocker"
      "hashicorp/tap/terraform"
      "grpcurl"

      ## Kubernetes
      "kubectl"
      "minikube"
      "derailed/k9s/k9s"
      "helm"
      "argoproj/tap/kubectl-argo-rollouts"
    ];
    casks =
      [ "docker" "github" "google-chrome" "logseq" "visual-studio-code" "zed" ];
    masApps = {
      "Bitwarden" = 1352778147;
      "WireGuard" = 1451685025;
      "Todoist" = 585829637;
    };
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision =
    inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Dock settings
  system.defaults.dock.autohide = true;
  system.defaults.dock.show-recents = false;

  # Set up keyboard
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 25;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;

  # Enable sudo authentication with Touch ID
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults.CustomUserPreferences = {
    "com.raycast.macos" = {
      raycastGlobalHotkey = "Command-49";
      raycastShouldFollowSystemAppearance = 1;
    };
  };

  system.activationScripts.extraActivation.enable = true;
  system.activationScripts.extraActivation.text = ''
    echo "Activating extra preferences..."
    # Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
    osascript -e 'tell application "System Preferences" to quit'

    # Let Raycast have cmd+space instead of Spotlight
    /usr/libexec/PlistBuddy /Users/toby/Library/Preferences/com.apple.symbolichotkeys.plist -c \
    "Set AppleSymbolicHotKeys:64:enabled false"
  '';

  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}

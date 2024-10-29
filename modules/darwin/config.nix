{ pkgs, ... }: {
  # Dock settings
  system.defaults.dock.autohide = true;
  system.defaults.dock.show-recents = false;

  # Set up keyboard
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 25;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;

  # Enable sudo authentication with Touch ID
  security.pam.enableSudoTouchIdAuth = true;

  system.activationScripts.extraActivation.enable = true;
  system.activationScripts.extraActivation.text = ''
    echo "Activating extra preferences..."
    # Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
    osascript -e 'tell application "System Preferences" to quit'

    # Symlink Java so /usr/libexec/java_home works
    ln -sf "${pkgs.jdk}/zulu-21.jdk" "/Library/Java/JavaVirtualMachines"
  '';

  system.activationScripts.postUserActivation.text = ''
    # Following line allows us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}

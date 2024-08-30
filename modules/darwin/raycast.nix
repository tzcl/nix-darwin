{ pkgs, user, ... }: {
  environment.systemPackages = with pkgs; [ raycast ];

  system.defaults.CustomUserPreferences = {
    "com.raycast.macos" = {
      raycastGlobalHotkey = "Command-49";
      raycastShouldFollowSystemAppearance = 1;
    };
  };

  system.activationScripts.extraActivation.text = ''
    # Let Raycast have cmd+space instead of Spotlight
    /usr/libexec/PlistBuddy ${user.home}/Library/Preferences/com.apple.symbolichotkeys.plist -c \
    "Set AppleSymbolicHotKeys:64:enabled false"
  '';
}

{ ... }: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    theme = "Catppuccin-Frappe";
    font = {
      name = "Fira Code";
      size = 13.0;
    };
    settings = {
      top_bar_edge = "top";
      tab_bar_style = "slant";
      enabled_layouts = "tall";
      macos_option_as_alt = "both";
      shell = "zsh -i";
    };
    keybindings = {
      # Opening new splits
      "cmd+enter" = "launch --cwd=current --type=window";
      "cmd+shift+t" = "new_tab_with_cwd";

      # Prompt editing
      "alt+backspace" = "send_text all x17";
      "super+backspace" = "send_text all x15";
      "super+left" = "send_text all x01";
      "super+right" = "send_text all x05";
    };
  };
}

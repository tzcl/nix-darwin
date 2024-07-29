{ ... }: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    theme = "Catppuccin-Frappe";
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 13.0;
    };
    settings = {
      top_bar_edge = "top";
      tab_bar_style = "slant";
      enabled_layouts = "splits, stack";
      macos_option_as_alt = "both";
      shell = "zsh -i";
    };
    keybindings = {
      # Opening new splits
      "cmd+enter" = "launch --cwd=current --type=window";
      "cmd+shift+t" = "new_tab_with_cwd";

      # Prompt editing
      "alt+backspace" = "send_text all \\x17";
      "super+backspace" = "send_text all \\x15";
      "super+left" = "send_text all \\x01";
      "super+right" = "send_text all \\x05";

      # Window management
      "alt+s" = "launch --location=vsplit";
      "alt+v" = "launch --location=hsplit";
      "alt+enter" = "launch --location=split";
      "alt+r" = "layout_action rotate";

      "alt+super+left" = "move_window left";
      "alt+super+right" = "move_window right";
      "alt+super+up" = "move_window up";
      "alt+super+down" = "move_window down";

      "shift+left" = "neighboring_window left";
      "shift+right" = "neighboring_window right";
      "shift+up" = "neighboring_window up";
      "shift+down" = "neighboring_window down";
    };
  };
}

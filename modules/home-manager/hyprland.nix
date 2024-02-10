{ lib, config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, SPACE, exec, wofi --show=drun --gtk-dark"
      ];
    };
  };
}

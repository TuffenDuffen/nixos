{ lib, config, pkgs, ... }:

{
  programs.nushell = {
    enable = true;
    extraEnv = ''
    $env.NU_LIB_DIRS = [
      $"($nu.default-config-dir)/modules"
    ]
    '';
  };
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
  home.file."nu-modules" = {
    source = ./../nushell;
    recursive = true;
    target = "${config.xdg.configHome}/nushell/modules/";
  };
}

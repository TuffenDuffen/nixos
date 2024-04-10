{ lib, config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [gcc cargo go];
  };
  home.file."nvim-config" = {
    source = ./../../nvim;
    recursive = true;
    target = "${config.xdg.configHome}/nvim";
  };
}

{ lib, config, pkgs, ... }:

{
  programs.nushell.extraConfig = "use dvsm.nu";
}

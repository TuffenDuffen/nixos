{ lib, config, pkgs, ... }:

{
  programs.nushell.extraConfig = "use ../nushell/dvsm.nu";
}

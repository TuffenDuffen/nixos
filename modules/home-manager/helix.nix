{ lib, config, pkgs, ... }:

{
  programs.helix = {
    enable = true;
    languages = builtins.fromTOML ''
      [[language]]
      name = "nu"
      file-types = ["nu"]
      shebangs = ["nu"]
      comment-token = "#"
      indent = { tab-width = 2, unit = "  " }
      language-servers = ["nu-lsp"]

      [[language]]
      name = "nix"
      formatter = { command = "alejandra" }

      [language-server.nu-lsp]
      command = "nu"
      args = ["--lsp"]
    '';
  };
}

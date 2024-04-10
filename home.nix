{
  config,
  pkgs,
  lib,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tuffend";
  home.homeDirectory = "/home/tuffend";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "adwaita-dark";
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-show-weekday = true;
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "system/locale" = {
      region = "sv_SE.UTF-8";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/desktop/input-sources" = {
      sources = [(lib.hm.gvariant.mkTuple ["xkb" "se"]) (lib.hm.gvariant.mkTuple ["xkb" "us"])];
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    pkgs.firefox
    pkgs.thunderbird
    pkgs.discord
    pkgs.gamemode
    pkgs.prismlauncher
    pkgs.vial

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

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

  programs.nushell.environmentVariables = {
    EDITOR = "hx";
  };

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
    source = ./nushell;
    recursive = true;
    target = "${config.xdg.configHome}/nushell/modules/";
  };

  programs.nushell.extraConfig = "use dvsm.nu";

  programs.lazygit = {
    enable = true;
  };

  programs.zellij = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
  };

  home.file."nvim-config" = {
    source = ./nvim;
    recursive = true;
    target = "${config.xdg.configHome}/nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

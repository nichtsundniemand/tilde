{ config, pkgs, ... }:

{
  home.username = "wirklichniemand";
  home.homeDirectory = "/home/wirklichniemand";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  home.packages = [
    # Basics
    pkgs.bat
    pkgs.brightnessctl
    pkgs.exa
    pkgs.git
    pkgs.htop
    pkgs.jq
    pkgs.qutebrowser
    pkgs.zsh

    # Development
    pkgs.cargo
    pkgs.cue
    pkgs.go

    # Media
    pkgs.mpv
    pkgs.pulsemixer
    pkgs.spotify
    pkgs.yt-dlp

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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/wirklichniemand/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.kakoune = {
    enable = true;
    plugins = [
      pkgs.gopls
      pkgs.kakounePlugins.kak-lsp
      pkgs.python310Packages.python-lsp-server
      pkgs.rust-analyzer
    ];

    config = {
      indentWidth = 0;
      tabStop = 4;
      numberLines.enable = true;

      hooks = [
        {
          name = "WinSetOption";
          option = "filetype=(c|cpp|go|rust|python)";
          commands = "lsp-enable-window";
        }
      ];
    };

    extraConfig = "eval %sh{kak-lsp --kakoune -s $kak_session}";
  };
}

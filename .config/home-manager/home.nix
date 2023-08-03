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
    pkgs.pipewire
    pkgs.pulsemixer
    pkgs.spotify
    pkgs.yt-dlp

    # Window management
    pkgs.sway
    pkgs.swaybg
    pkgs.waybar
    pkgs.wofi

    pkgs.xwayland

    pkgs.aileron
    pkgs.fira
    pkgs.fira-code
    pkgs.roboto

    # Other Packages - uninstalled
    # cutter-2.2.1
    # dhex-0.69
    # dive-0.10.0
    # efibootmgr-18
    # entr-5.2
    # evolution-3.48.3
    # firefox-115.0b9
    # fragments-2.1
    # gdb-13.2
    # geary-43.0
    # gimp-2.10.34
    # helvum-0.4.0
    # hexedit-1.6
    # hyx-2021.06.09
    # i2c-tools-4.3
    # imv-4.4.0
    # inkscape-1.2.2
    # keepassxc-2.7.4
    # kpat-23.04.2
    # libreoffice-7.4.7.2-wrapped
    # mediainfo-23.04
    # mesa-23.1.3
    # minicom-2.8
    # nautilus-44.2.1
    # ncdu-2.2.2
    # netcat-gnu-0.7.1
    # nmap-7.94
    # pulseview-0.4.2
    # pv-1.6.20
    # qemu-8.0.2
    # radare2-5.8.8
    # seahorse-43.0
    # simple-scan-44.0
    # smartmontools-7.3
    # socat-1.7.4.4
    # sqlc-1.18.0
    # strace-6.4
    # tcpdump-4.99.4
    # telegram-desktop-4.8.4
    # wesnoth-1.16.9
    # wireshark-qt-4.0.6

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

    # Hacks to allow running pipewire as a user service...
    ".config/systemd/user/pipewire.service".source = "${pkgs.pipewire.out}/lib/systemd/user/pipewire.service";
    ".config/systemd/user/pipewire.socket".source = "${pkgs.pipewire.out}/lib/systemd/user/pipewire.socket";
    ".config/systemd/user/pipewire-pulse.service".source = "${pkgs.pipewire.pulse}/lib/systemd/user/pipewire-pulse.service";
    ".config/systemd/user/pipewire-pulse.socket".source = "${pkgs.pipewire.pulse}/lib/systemd/user/pipewire-pulse.socket";
    ".config/systemd/user/wireplumber.service".source = "${pkgs.wireplumber.out}/lib/systemd/user/wireplumber.service";
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

  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.kakoune = {
    enable = true;
    plugins = [
      pkgs.gopls
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

    extraConfig = "eval %sh{${pkgs.kakounePlugins.kak-lsp}/bin/kak-lsp --kakoune -s $kak_session}";
  };
}

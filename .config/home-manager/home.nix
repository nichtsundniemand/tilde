{ config, pkgs, specialArgs, ... }:

let
  inherit (specialArgs) sops-nix;
in
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
    pkgs.elvish
    pkgs.exa
    pkgs.htop
    pkgs.jq
    pkgs.zsh

    # Development
    pkgs.cargo
    pkgs.cue
    pkgs.go

    # Media
    pkgs.pipewire
    pkgs.pulsemixer
    pkgs.spotify

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

    # This is kind of a hack - don't forget to link this output to `/run/opengl-driver/`
    pkgs.mesa.drivers

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

    # elvish
    ".config/elvish/rc.elv".text = ''
        use direnv
        use re
        use str

        if (not (== 0 (str:compare $E:TERM "linux"))) {
        	set edit:prompt = {
        		var bg = green
        		var fg = white

        		var path = (re:replace '^~$' '🏠' (tilde-abbr $pwd))
        		put (styled ' '$path' ' bg-$bg fg-$fg)(styled ' ' fg-$bg)
        	}
        }
    '';
    ".config/elvish/lib/direnv.elv".text = ''
        ## hook for direnv
        set @edit:before-readline = $@edit:before-readline {
        	try {
        		var m = [("${pkgs.direnv}/bin/direnv" export elvish | from-json)]
        		if (> (count $m) 0) {
        			set m = (all $m)
        			keys $m | each { |k|
        				if $m[$k] {
        					set-env $k $m[$k]
        				} else {
        					unset-env $k
        				}
        			}
        		}
        	} catch e {
        		echo $e
        	}
        }
    '';
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

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;

      userName = "nichtsundniemand";
      userEmail = "rufus.schaefing@gmail.com";

      extraConfig.core.editor = "${config.programs.kakoune.package}/bin/kak";
      delta.enable = true;
    };

    kakoune = {
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

    kitty = {
      enable = true;
      settings = {
        allow_remote_control = true;
        font_size = 12;
        background_opacity = "0.985";
      };
      theme = "Afterglow";
    };

    mpv = {
      enable = true;
      config.ytdl-format = "bestvideo[height<=720]+bestaudio/best";
      scriptOpts.ytdl_hook.ytdl_path = "${pkgs.yt-dlp}/bin/yt-dlp";
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      bars = [];
      modifier = "Mod4";
      menu = "${pkgs.wofi}/bin/wofi -d --show run -s ${./sway/styles/wofi_black-yellow.css}";
      terminal = "${config.programs.kitty.package}/bin/kitty -1";
      # This is a bit ugly but oh well...
      keybindings = with config.wayland.windowManager.sway.config; {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+q" = "exec ${pkgs.qutebrowser}/bin/qutebrowser";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+1" = "workspace 1";
        "${modifier}+2" = "workspace 2";
        "${modifier}+3" = "workspace 3";
        "${modifier}+4" = "workspace 4";
        "${modifier}+5" = "workspace 5";
        "${modifier}+6" = "workspace 6";
        "${modifier}+7" = "workspace 7";
        "${modifier}+8" = "workspace 8";
        "${modifier}+9" = "workspace 9";
        "${modifier}+0" = "workspace 10";
        "${modifier}+Shift+1" = "move container to workspace 1";
        "${modifier}+Shift+2" = "move container to workspace 2";
        "${modifier}+Shift+3" = "move container to workspace 3";
        "${modifier}+Shift+4" = "move container to workspace 4";
        "${modifier}+Shift+5" = "move container to workspace 5";
        "${modifier}+Shift+6" = "move container to workspace 6";
        "${modifier}+Shift+7" = "move container to workspace 7";
        "${modifier}+Shift+8" = "move container to workspace 8";
        "${modifier}+Shift+9" = "move container to workspace 9";
        "${modifier}+Shift+0" = "move container to workspace 10";
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+f" = "fullscreen";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "focus mode_toggle";
        "${modifier}+a" = "focus parent";
        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+minus" = "scratchpad show";
        "${modifier}+r" = "mode \"resize\"";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
      };
      modes = {
        resize = {
          "Left" = "resize shrink width 10px";
          "Down" = "resize grow height 10px";
          "Up" = "resize shrink height 10px";
          "Right" = "resize grow width 10px";
          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };
      output = {
        "eDP-1" = {
          pos = "0 0";
          res = "1920x1080";
        };
        "HDMI-A-1" = {
          pos = "1920 0";
          res = "1920x1080";
        };
      };
    };
    extraConfig = ''
      include ${./sway/styles/black-yellow}
      exec ${pkgs.waybar}/bin/waybar -c ${./sway/waybar.json} -s ${./sway/styles/waybar_black-yellow.css}
    '';
  };

  xdg.userDirs = {
    enable = true;
    desktop = "${config.home.homeDirectory}/tmp";
    download = "${config.home.homeDirectory}/downloads";
    templates = "${config.home.homeDirectory}/";
    publicShare = "${config.home.homeDirectory}/";
    documents = "${config.home.homeDirectory}/docs";
    music = "${config.home.homeDirectory}/media/music";
    pictures = "${config.home.homeDirectory}/media/images";
    videos = "${config.home.homeDirectory}/media/movies";
  };
}

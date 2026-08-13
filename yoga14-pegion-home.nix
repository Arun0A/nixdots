{ config, pkgs, ... }:
let
  myaliases = {
    ll = "ls -latr";
    l = "ls -lhtr";
    
    yy = "tmux new-window -n yazi yazi";

    ".." = "cd ..";
    
    "nrs" = "sudo nixos-rebuild switch --flake /home/pegion/.nixdots/#yoga14";

    "hms" = "home-manager switch --flake /home/pegion/.nixdots";

    "icat" = "kitty +kitten icat";

    "cd" = "z"; 
    "cdi" = "zi";

	"loff" = "tmux new-window -d -n libreoffice libreoffice";

	"cdx" = "term-cut";
	"cdp" = "term-paste";
  };

in
{

  home.sessionVariables = {
    PATH = "$HOME/.local/bin:$HOME/scripts:$PATH";
  };

  programs.zsh.initContent = ''

	# export MANPAGER="sh -c 'sed -u -e \"s/\\\\x1B\\[[0-9;]*m//g; s/. \\\\x08//g\" | bat -p -lman'"
	export MANPAGER='nvim --clean +Man!'

    pdf() {
      if [ -n "$1" ]; then
		tmux new-window -d -n sioyek sioyek "$(find . -maxdepth "$1" -name '*.pdf' | sk)"
      else
		tmux new-window -d -n sioyek sioyek "$(find . -name '*.pdf' | sk)"
      fi
    }

	tdg() {
	  if [ "$1" = "." ]; then
	    sudo tailscale file get --loop=true "$PWD"
	  elif [ -n "$1" ]; then
	    sudo tailscale file get --loop=true "$1"
	  else
	    sudo tailscale file get --loop=true "$HOME/Downloads/"
	  fi
	}

	tds() {
	  if [ "$1" = "." ]; then
	    sudo tailscale file cp "$PWD" nipa:
	  elif [ -n "$1" ]; then
	    sudo tailscale file cp "$1" nipa:
	  else
	    echo "Usage: tds <file-or-directory>"
	    return 1
	  fi
	}

	v() {
      if [ -n "$1" ]; then
		tmux new-window -n nvim nvim $1
      else
		tmux new-window -n nvim nvim "$(find . -maxdepth 1 | sk)"
      fi
	}

	cdy() {
		local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
		yazi "$@" --cwd-file="$tmp"
		if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
			builtin cd -- "$cwd"
		fi
		rm -f -- "$tmp"
	}

	term-cut() {
		local buf="$HOME/.terminal_buffer"

		[[ $# -eq 0 ]] && {
			echo "Usage: term-cut <files...>"
			return 1
		}

		touch "$buf"

		for f in "$@"; do
			local abs="''${f:A}"

			if [[ -e "$abs" ]]; then
				grep -Fxq "$abs" "$buf" 2>/dev/null || {
					echo "$abs" >> "$buf"
					echo "Added: $f"
				}
			fi
		done
	}

	term-paste() {
		local buf="$HOME/.terminal_buffer"

		[[ ! -f "$buf" ]] && touch "$buf"

		# --list
		if [[ "$1" == "--list" ]]; then
			if [[ ! -s "$buf" ]]; then
				echo "Buffer empty"
				return
			fi

			nl -w2 -s': ' "$buf"
			return
		fi

		# --clear
		if [[ "$1" == "--clear" ]]; then
			: > "$buf"
			echo "Buffer cleared"
			return
		fi

		# --pick
		if [[ "$1" == "--pick" ]]; then
			command -v sk >/dev/null || {
				echo "sk not found"
				return 1
			}

			local selected
			selected=$(sk -m < "$buf")

			[[ -z "$selected" ]] && return

			local tmp
			tmp=$(mktemp)

			while IFS= read -r file; do
				if print -l -- "$selected" | grep -Fxq "$file"; then
					if [[ -e "$file" ]]; then
						mv "$file" .
						echo "Moved: ''${file:t}"
					fi
				else
					echo "$file" >> "$tmp"
				fi
			done < "$buf"

			mv "$tmp" "$buf"
			return
		fi

		# pattern or everything
		local pattern="''${1:-*}"
		local tmp
		tmp=$(mktemp)

		while IFS= read -r file; do
			# Skip stale entries
			if [[ ! -e "$file" ]]; then
				continue
			fi

			if [[ "''${file:t}" == ''${~pattern} ]]; then
				mv "$file" .
				echo "Moved: ''${file:t}"
			else
				echo "$file" >> "$tmp"
			fi
		done < "$buf"

		mv "$tmp" "$buf"
	}
	
	runbinary() {
		(( $# )) || {
			echo "Usage: runbinary <program> [args...]"
			return 1
		}

		local prog="$1"
		shift

		local dir
		dir="$(cd "$(dirname "$prog")" && pwd)"

		local -a libdirs=(
			"$dir"
			"$dir/lib"
			"$dir/libs"
			"$dir/lib64"
			"$dir/bin"
			"$dir/bin/amd64"
			"$dir/bin/x86_64"
			"$dir/bin/x86"
		)

		local ldpath="$LD_LIBRARY_PATH"

		for d in "''${libdirs[@]}"; do
			[[ -d "$d" ]] && ldpath="$d''${ldpath:+:$ldpath}"
		done

		(
			export LD_LIBRARY_PATH="$ldpath"
			exec "$prog" "$@"
		)
	}
	
    purify-nix-btw() {
      sudo nix-env --delete-generations +2 --profile /nix/var/nix/profiles/system
      home-manager expire-generations -1days
      sudo nix-collect-garbage -d
      sudo nix-store --optimise
    }

    purify-nix-all() {
      sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
      nix-env --delete-generations old
      home-manager expire-generations 0days
      rm -rf ~/.cache/nix
      sudo nix-collect-garbage -d
      sudo nix-store --optimise
    }

    purify-nix-nuclear() {
      sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
      nix-env --delete-generations old
      home-manager expire-generations 0days
      sudo find /nix/var/nix/gcroots/per-user -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +
      rm -rf ~/.cache/nix ~/.cache/nix/eval-cache
      sudo nix-collect-garbage -d
      sudo nix-store --gc
      sudo nix-store --optimise
    }
  '';

  home.username = "pegion";
  home.homeDirectory = "/home/pegion";

  home.stateVersion = "25.11";

  home.file.".xinitrc".source = ./x/.xinitrc;

  ################
  # Packages
  ################

  home.packages = with pkgs; [
  	tealdeer
	file
    net-tools
	inetutils
    lsof
    kitty
    bc
    broot
	skim
    zoxide
    firefox
    fzf
    ripgrep
    bat
    mpv
    pamixer
    brightnessctl
    redshift
    xev
    blueman
    curl
    feh
    tmux
    scrot
    kdePackages.dolphin
    kdePackages.kio-admin
    vivaldi
    google-chrome
    brave
    zoom-us
    ffmpeg
    qtox
    localsend
    vscode.fhs
    antigravity-fhs
    emacs
    thunderbird
    discord
    sioyek
    qrcp
    yazi
    qimgv
    libreoffice
    appimage-run
    yt-dlp
    blobdrop
    (pkgs.texlive.withPackages (ps: with ps; [
      latexmk
      scheme-medium
    ]))
    qbittorrent
    nicotine-plus
	gimp
    kdePackages.kdenlive
    audacity
    audacious
	mpc
	rmpc
	cava

	clang-tools

    xdotool
    dwmblocks
    touchegg
    playerctl
    xmodmap

	usbutils
	android-file-transfer
	jmtpfs
	libmtp

    nerd-fonts.jetbrains-mono

	dunst
	libnotify

	nixfmt
  ];
  
  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };


  ################
  # dwmblocks
  ################
  home.file.".config/dwmblocks/config.h".source = ./dwmblocks/config.h;
  
  home.file.".config/dwmblocks/scripts/volume".source = ./dwmblocks/scripts/volume;
  home.file.".config/dwmblocks/scripts/volume".executable = true;

  home.file.".config/dwmblocks/scripts/network".source = ./dwmblocks/scripts/network;
  home.file.".config/dwmblocks/scripts/network".executable = true;

  home.file.".config/dwmblocks/scripts/memory".source = ./dwmblocks/scripts/memory;
  home.file.".config/dwmblocks/scripts/memory".executable = true;
  
  home.file.".config/dwmblocks/scripts/cputemp".source = ./dwmblocks/scripts/cputemp;
  home.file.".config/dwmblocks/scripts/cputemp".executable = true;
  
  home.file.".config/dwmblocks/scripts/battery".source = ./dwmblocks/scripts/battery;
  home.file.".config/dwmblocks/scripts/battery".executable = true;
  
  home.file.".config/dwmblocks/scripts/datetime".source = ./dwmblocks/scripts/datetime;
  home.file.".config/dwmblocks/scripts/datetime".executable = true;

  ################
  # Bash
  ################

  programs.bash = {
    enable = true;
    shellAliases = myaliases;
  };

  ################
  # Zsh
  ################

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
    shellAliases = myaliases;
  };

  ################
  # vim 
  ################
  programs.vim = {
    enable = true;
    extraConfig = ''
      set number relativenumber
      set expandtab
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set clipboard=unnamedplus
      set noerrorbells
      set novisualbell
	  set shortmess+=I
      imap jj <Esc>
    '';
  };

  ################
  # neovim 
  ################
  programs.neovim = {
    enable = true;
    initLua = builtins.readFile ./nvim/init.lua;
    withRuby = false;
    withPython3 = false;
    plugins = with pkgs.vimPlugins; [
      nvim-colorizer-lua
    ];
	extraPackages = with pkgs; [
	  nixd
	  lua-language-server
	  clang-tools
	];
  };

  ################
  # kitty 
  ################
  programs.kitty = {
    enable = false;
    # extraConfig = ''
    #   confirm_os_window_close 0
    #   map ctrl+backspace send_text all \x17
    #   enable_audio_bell no
    #   scrollback_fill_enlarged_window yes
    # '';
  };
  home.file.".config/kitty".source = ./kitty;

  ################
  # dunst 
  ################
  home.file.".config/dunst".source = ./dunst;
  
  ################
  # tmux 
  ################
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g terminal-overrides ",xterm-kitty:Tc"

      # unbind C-b
      # set-option -g prefix C-a
	  set -g prefix C-SPACE
      # bind-key C-a send-prefix

      # bind | split-window -h
      # bind - split-window -v
      # unbind '"'
      # unbind %

	  bind-key -n M-1 select-window -t :1
	  bind-key -n M-2 select-window -t :2
	  bind-key -n M-3 select-window -t :3
	  bind-key -n M-4 select-window -t :4
	  bind-key -n M-5 select-window -t :5
	  bind-key -n M-6 select-window -t :6
	  bind-key -n M-7 select-window -t :7
	  bind-key -n M-8 select-window -t :8
	  bind-key -n M-9 select-window -t :9

      bind -n M-J select-pane -D
      bind -n M-K select-pane -U
      bind -n M-H select-pane -R
      bind -n M-L select-pane -L
	  bind b set -g status

	  set -g status-position bottom
	  set -g status-justify right
	  set -g status-style "bg=default"

      # set -g status-bg "#3f5c4c"
      # set -g status-fg "#232424"
	  # set -g window-status-current-style "fg=#3f5c4c bold"
      
      # set -g status-bg "#9c9c9c"
      # set -g status-fg "#232424"
	  set -g window-status-current-style "fg=#9c9c9c bold"

	  set -g status-right " (#S)"
	  set -g status-left ""

      set -g mouse on
      set -g default-terminal "tmux-256color"

	  set -a terminal-features "tmux-256color:RGB"
	  set -g base-index 1
	  set -g renumber-windows on
	  set -g mode-keys vi 

      set-option -g allow-rename off
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
	  bind c new-window -c "#{pane_current_path}"
    '';
  };

  ################
  # picom 
  ################
  home.file.".config/picom/picom.conf".source = ./picom/picom.conf;

  ################
  # broot 
  ################

  programs.broot = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  ################
  # zoxide 
  ################

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  ################
  # Clipboard manager
  ################

  services.copyq = {
    enable = true;
    systemdTarget = "xsession.target";
  };

  ################
  # touchegg 
  ################
  home.file.".config/touchegg/touchegg.conf".source = ./touchegg/touchegg.conf;

  ################
  # Cursor
  ################
  
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 14;
	gtk.enable = true;
    x11.enable = true;
  };

  ################
  # GTK 
  ################

  gtk = {
    enable = true;
  
    theme = {
      package = pkgs.graphite-gtk-theme;
      name = "Graphite-Dark";
    };
  
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
	  gtk-error-bell = 0;
    };
  
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
	  gtk-error-bell = 0;
    };

    gtk4.theme = config.gtk.theme;
  };

  ################
  # xdg mimeApps
  ################
  # find $(echo $XDG_DATA_DIRS | tr ':' ' ') -path '*/applications/*.desktop' 2>/dev/null | sort 

  xdg.mimeApps = {
    enable = true;
  
    defaultApplications = {
      # Directories
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
  
      # Browser
      "text/html" = [ "brave-browser.desktop" ];
      "x-scheme-handler/http" = [ "brave-browser.desktop" ];
      "x-scheme-handler/https" = [ "brave-browser.desktop" ];
  
      # Mail
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
  
      # PDF
      "application/pdf" = [ "sioyek.desktop" ];
  
      # Images
      "image/png" = [ "qimgv.desktop" ];
      "image/jpeg" = [ "qimgv.desktop" ];
      "image/gif" = [ "qimgv.desktop" ];
      "image/webp" = [ "qimgv.desktop" ];
      "image/bmp" = [ "qimgv.desktop" ];
      "image/tiff" = [ "qimgv.desktop" ];
      "image/svg+xml" = [ "qimgv.desktop" ];
      "image/x-xpixmap" = [ "qimgv.desktop" ];
      "image/x-portable-pixmap" = [ "qimgv.desktop" ];
  
      # Video
      "video/mp4" = [ "mpv.desktop" ];
      "video/x-matroska" = [ "mpv.desktop" ];
      "video/webm" = [ "mpv.desktop" ];
      "video/quicktime" = [ "mpv.desktop" ];
      "video/x-msvideo" = [ "mpv.desktop" ];
      "video/mpeg" = [ "mpv.desktop" ];
  
      # Audio
      "audio/mpeg" = [ "audacious.desktop" ];
      "audio/flac" = [ "audacious.desktop" ];
      "audio/ogg" = [ "audacious.desktop" ];
      "audio/wav" = [ "audacious.desktop" ];
      "audio/x-wav" = [ "audacious.desktop" ];
      "audio/aac" = [ "audacious.desktop" ];
  
      # LibreOffice Writer
      "application/msword" = [ "writer.desktop" ];
      "application/rtf" = [ "writer.desktop" ];
      "application/vnd.oasis.opendocument.text" = [ "writer.desktop" ];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "writer.desktop" ];
  
      # LibreOffice Calc
      "application/vnd.ms-excel" = [ "calc.desktop" ];
      "application/vnd.oasis.opendocument.spreadsheet" = [ "calc.desktop" ];
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [ "calc.desktop" ];
  
      # LibreOffice Impress
      "application/vnd.ms-powerpoint" = [ "impress.desktop" ];
      "application/vnd.oasis.opendocument.presentation" = [ "impress.desktop" ];
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "impress.desktop" ];
  
      # Plain text / source code
      "text/plain" = [ "nvim.desktop" ];
      "text/x-c" = [ "nvim.desktop" ];
      "text/x-c++" = [ "nvim.desktop" ];
      "text/x-python" = [ "nvim.desktop" ];
      "text/x-java" = [ "nvim.desktop" ];
      "text/x-rust" = [ "nvim.desktop" ];
      "application/json" = [ "nvim.desktop" ];
      "application/xml" = [ "nvim.desktop" ];
    };
  };
  
  ################
  # MPD
  ################
  services.mpd = {
    enable = true;
  
    musicDirectory = "/home/pegion/Music";
  
    network = {
      listenAddress = "127.0.0.1";
      port = 6600;
    };
  
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire"
      }
      audio_output {
        type   "fifo"
        name   "my_fifo"
        path   "/tmp/mpd.fifo"
        format "44100:16:2"
      }
    '';
  };

  services.mpdris2 = {
    enable = true;
    multimediaKeys = true;
  };


  ################
  # Home manager
  ################

  programs.home-manager.enable = true;
}

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
    PATH = "$HOME/.local/bin:$PATH";
  };

  programs.zsh.initContent = ''
    pdf() {
      if [ -n "$1" ]; then
		tmux new-window -d -n sioyek sioyek "$(find . -maxdepth "$1" -name '*.pdf' | sk)"
      else
		tmux new-window -d -n sioyek sioyek "$(find . -name '*.pdf' | sk)"
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
    croc
    (pkgs.texlive.withPackages (ps: with ps; [
      latexmk
      scheme-medium
    ]))
    qbittorrent
    nicotine-plus
    krita
    kdePackages.kdenlive
    audacity
    audacious

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

	nixfmt-rfc-style
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
    plugins = with pkgs.vimPlugins; [
      nvim-colorizer-lua
    ];
	extraPackages = with pkgs; [
	  nixd
	  lua-language-server
	  clang-tools
	];
  };
  home.file.".config/nvim".source = ./nvim;

  ################
  # kitty 
  ################
  programs.kitty = {
    enable = true;
    # extraConfig = ''
    #   confirm_os_window_close 0
    #   map ctrl+backspace send_text all \x17
    #   enable_audio_bell no
    #   scrollback_fill_enlarged_window yes
    # '';
  };
  home.file.".config/kitty".source = ./kitty;
  
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
  # Home manager
  ################

  programs.home-manager.enable = true;
}

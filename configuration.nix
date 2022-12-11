# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./zfs.nix
    ];

  networking = {
    hostName = "hoshi"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager = {
      enable = true; # Easiest to use and most distros use this by default.
      firewallBackend = "nftables";
    };
    # vlans = {
    #   vlan3 = {
    #     id = 3;
    #     interface = "enp8s0";
    #   };
    # };

    proxy = {
      # default = "http://user:password@proxy:port/";
      default = "http://192.168.0.108:7890";
      noProxy = "127.0.0.1,localhost,internal.domain";
    };

    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    firewall.enable = true;
  };

  time = {
    timeZone = "Asia/Shanghai";
    hardwareClockInLocalTime = true;
  };

  nixpkgs = { config.allowUnfree = true; };
  nix = {
    settings = {
      auto-optimise-store = true;
      max-jobs = 16;
      substituters =
        [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ rime ];
    };
  };
  console = {
    earlySetup = true;
    # packages = with pkgs; [ terminus_font ];
    # font = "ter-v16n";
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };
  fonts = {
    fontconfig = {
      defaultFonts = {
        #        sansSerif = [ "Source Sans Pro" ];
        #        serif = [ "Source Serif Pro" ];
        monospace = [ "FiraCode Nerd Font Mono" ];
      };
    };
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      source-code-pro
      wqy_zenhei
      fira-code-symbols
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = [ "nvidia" "amdgpu" ];

      # Enable the Plasma 5 Desktop Environment.
      desktopManager = {
        plasma5 = {
          enable = true;
          useQtScaling = true;
          supportDDC = true;
        };
      };
      displayManager = { sddm.enable = true; };

      # Configure keymap in X11
      # xkbOptions = {
      #   "eurosign:e";
      #   "caps:escape" # map caps to escape.
      # };

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    };

    kmscon = {
      enable = true;
      hwRender = true;
      fonts = [
        {
          name = "FiraCode Nerd Font Mono";
          package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
        }
      ];
    };

    fstrim.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable the OpenSSH daemon.
    openssh.enable = true;
    emacs = {
      enable = true;
      # defaultEditor = true;
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    video = { hidpi.enable = true; };
    # sensor.hddtemp.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.fish;
    users.aya = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [ ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    bat-extras.batman
    bat-extras.batpipe
    bat-extras.batgrep
    bat-extras.batdiff
    bat-extras.batwatch
    bat-extras.prettybat
    diff-so-fancy
    fd
    fzf
    gh
    jq
    parted
    spotify
    tldr
    tdesktop
    neovim
    emacs
    wget
    neofetch
    ripgrep
    tree
    htop
    direnv
    git
    cachix
    nixpkgs-fmt
    google-chrome
    vscode
    kitty
    jetbrains.clion
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    fish = { enable = true; };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    ccache.enable = true;
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system = {
    # autoUpgrade = {
    #   enable = true;
    #   flake = "github:imbillow/nix.git";
    #   randomizedDelaySec = "12h";
    #   flags = [ "--impure" ];
    # };
    # copySystemConfiguration = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "unstable"; # unstable ?
  };
}

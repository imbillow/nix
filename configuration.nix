# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }: {
  imports = [
    # Include the results of the hardware scan.
    #./hardware-configuration.nix
    #<home-manager/nixos>
  ];

  fileSystems = {
    "/".options =
      [ "compress=zstd" "noatime" "ssd" "space_cache=v2" "discard=async" ];
    "/home".options =
      [ "compress=zstd" "noatime" "ssd" "space_cache=v2" "discard=async" ];
    "/nix".options =
      [ "compress=zstd" "noatime" "ssd" "space_cache=v2" "discard=async" ];
    "/var/log".options =
      [ "compress=zstd" "noatime" "ssd" "space_cache=v2" "discard=async" ];
    "/.snapshots".options =
      [ "compress=zstd" "noatime" "ssd" "space_cache=v2" "discard=async" ];
  };

  # Use the grub EFI boot loader.
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        efiSupport = true;
        useOSProber = true;
        device = "nodev";
      };
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };

  networking = {
    hostName = "hoshi"; # Define your hostname.
    # Pick only one of the below networking options.
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

    # Configure network proxy if necessary
    # proxy = {
    #   default = "http://user:password@proxy:port/";
    #   proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    # };

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  nixpkgs = { config.allowUnfree = true; };
  nix = {
    settings = {
      max-jobs = 24;
      substituters =
        [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "C.UTF-8";
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ rime ];
    };
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };
  fonts = {
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Source Sans Pro" ];
        serif = [ "Source Serif Pro" ];
        monospace = [ "Iosevka Nerd Font" ];
      };
    };
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      fira-code-symbols
      source-serif-pro
      source-sans-pro
      (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" ]; })
    ];
  };

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = [ "nvidia" ];

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

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable the OpenSSH daemon.
    openssh.enable = true;
    emacs = {
      # enable = true;
      defaultEditor = true;
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    opengl.enable = true;
    video = { hidpi.enable = true; };
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
    neovim
    emacs
    wget
    neofetch
    ripgrep
    tree
    htop
    git
    kitty
    google-chrome
    cachix
    rnix-lsp
    nixfmt
    gnumake
    pkg-config
    cmake
    meson
    ninja
    clang_14
    clang-tools_14
    lld_14
    lldb_14
    mold
    opam
    (python3.withPackages (x: with x; [ pip pyyaml black ipython rzpipe ]))
    cabal2nix
    nix-prefetch-git
    cabal-install
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
    autoUpgrade = {
      enable = true;
      flake = "github:imbillow/nix.git";
      randomizedDelaySec = "12h";
      flags = [ "--impure" ];
    };
    copySystemConfiguration = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "22.11"; # unstable ?
  };

}

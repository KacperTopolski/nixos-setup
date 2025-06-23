# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

inputs: { config, pkgs, ... }:

let
  kt = import ./my-packages/all-packages.nix pkgs;
in {
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = "nix-command flakes";

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    useOSProber = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
  };
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.kacper = {
    isNormalUser = true;
    description = "kacper";
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" "docker" ];
    packages = with pkgs; [];
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "kacper";

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.fixed-gt.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    lm_sensors
    pciutils
    file
    htop
    neofetch
    vim
    wget
    coreutils-full
    cntr
    gnumake
    libgcc
    gcc

    cargo
    rustc
    libiconv
    openssl
    pkg-config
    btop

    (python312.withPackages (p: [ p.sympy p.pip p.termcolor p.tqdm p.mypy p.types-tqdm p.requests p.numpy p.matplotlib ]))
    libreoffice
    ghidra
    # nasm
    # gdb
    gparted
    discord
    vlc
    simple-scan
    kt.upm
    kt.cp-setup
    kt.utils
    mangohud
    transmission_3-qt
    protonup # you have to run this
    libsForQt5.booth
    localsend
    dconf2nix
    texlive.combined.scheme-full
    google-chrome
    wine64
    kt.pdf-gear
    # jetbrains.idea-community-bin
    jetbrains.rust-rover
    prismlauncher
  ];

  programs.java = {
    enable = true;
    package = (pkgs.jdk21.override { enableJavaFX = true; });
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    corefonts
    vistafonts
  ];

  documentation.man.generateCaches = false;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    '';
  };
  users.defaultUserShell = pkgs.fish;

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
  programs.nix-ld.enable = true;

  virtualisation.docker.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [
    kt.dcpt500wlpr
    kt.dcpt500w-cupswrapper
  ];

  hardware.printers = {
    ensurePrinters = [
      {
        name = "DCP-T500W";
        deviceUri = "lpd://192.168.100.4/BINARY_P1";
        model = "brother_dcpt500w_printer_en.ppd";
      }
    ];
  };

  # Scanner
  hardware.sane.enable = true;
  hardware.sane.brscan5 = {
    enable = true;
    netDevices = {
      brother = {
        ip = "192.168.100.4";
        model = "DCP-T500W";
      };
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false;
  hardware.nvidia.prime = {
    # sync.enable = true;
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ]; #localsend

  system.stateVersion = "25.05";
}

# To run manually:
# protonup
# sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
# sudo nix-channel --update


#todo: gnome terminal overlay
#todo2: nixos hardware

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let 
  kt = import ./my-packages/all-packages.nix pkgs;
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = "nix-command flakes";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Cinnamon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kacper = {
    isNormalUser = true;
    description = "kacper";
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "kacper";

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pciutils
    file
    htop
    neofetch
    vim
    wget
    coreutils-full
    cntr
    gnumake
    git
    libgcc
    gcc
    jdk21
    (python312.withPackages (p: [ p.sympy p.pip ]))
    libreoffice
    ghidra
    discord
    vscode
    vlc
    simple-scan
    kt.upm
    mangohud
    protonup # you have to run this
  ];

  programs.vim.defaultEditor = true;

  virtualisation.docker.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # services.printing.logLevel = "debug";
  # services.avahi = {
  #   enable = true;
  #   nssmdns4 = true;
  #   openFirewall = true;
  # };

  # Printer
  services.printing.drivers = [
    kt.dcpt500wlpr
    kt.dcpt500w-cupswrapper
  ];

  hardware.printers = {
    ensurePrinters = [
      {
        name = "DCP-T500W";
        deviceUri = "lpd://192.168.100.3/BINARY_P1";
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
        ip = "192.168.100.3";
        model = "DCP-T500W"; 
      };      
    };
  };

  services.xserver.videoDrivers = ["nvidia"];
  # services.xserver.videoDrivers = ["amdgpu"];

  hardware.nvidia.modesetting.enable = true;

  hardware.nvidia.prime = {
    sync.enable = true;

    # integrated
    # amdgpuBusId = "PCI:6:0:0"
    intelBusId = "PCI:0:2:0";

    # dedicated
    nvidiaBusId = "PCI:1:0:0";
  };
  
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };

  programs.steam = {
    enable = true;
#    remotePlay.opensFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

# home mananger todo
#  programs.git = {
#    enable = true;
#    userName  = "John Doe";
#    userEmail = "johndoe@example.com";
#    aliases = {
#      co = "checkout";
#      st = "status";
#    };
#  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}

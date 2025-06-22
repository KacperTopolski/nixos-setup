# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

inputs: { config, pkgs, ... }:

let
  kt = import ./my-packages/all-packages.nix pkgs;
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
    sha256 = "1mwq9mzyw1al03z4q2ifbp6d0f0sx9f128xxazwrm62z0rcgv4na";
  };
in {
  imports = [
    ./hardware-configuration.nix
    (import "${home-manager}/nixos")
  ];

  nix.settings.experimental-features = "nix-command flakes";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "kacper";

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    nbfc-linux
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

  # Printer
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
#    remotePlay.opensFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  home-manager.backupFileExtension = "backup";
  home-manager.useGlobalPkgs = true;
  home-manager.users.kacper = {config, pkgs, ...}: {

    systemd.user.services.conky-service = {
      Service = {
        Restart = "always";
        RestartSec = "1";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
        ExecStart = "${pkgs.conky}/bin/conky -c /etc/nixos/conky.conf";
      };

      Unit.After = [ "graphical-session.target" ];
      Install.WantedBy = [ "graphical-session.target" ];
    };

    dconf.settings = {
      "org/cinnamon/desktop/keybindings/wm" = {
        switch-to-workspace-left = [ "<Primary><Super>Left" ];
        switch-to-workspace-right = [ "<Primary><Super>Right" ];
        switch-to-workspace-up = [ "<Primary><Super>Up" ];
        switch-to-workspace-down = [ "<Primary><Super>Down" ];
      };
      "org/cinnamon/desktop/keybindings/custom-keybindings/custom0" = {
        binding = [ "<Shift><Super>s" ];
        command = "screentool";
        name = "screentool";
      };
    };

    programs.git = {
      enable = true;
      userName  = "Kacper Topolski";
      userEmail = "kacpertopolski@op.pl";
      aliases = {
        co = "checkout";
        st = "status";
      };
      extraConfig = {
        push.autoSetupRemote = true;
        pull.rebase = true;
        safe.directory = "*";
      };
    };
    programs.vscode = {
      enable = true;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      mutableExtensionsDir = false;

      # Extensions
      extensions = with pkgs.vscode-extensions; [
        ms-vscode.cpptools
        ms-vscode-remote.remote-ssh
        ms-python.python
        ms-python.vscode-pylance
        mhutchie.git-graph
        jnoortheen.nix-ide
        #kt.homie-vscode
        ms-vsliveshare.vsliveshare
      ];

      userSettings = {
        "editor.fontSize" = 12;
        "editor.fontFamily" = "'Jetbrains Mono', 'monospace', monospace";
        "terminal.integrated.fontSize" = 12;
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace', monospace";
        "window.zoomLevel" = 1;
        "workbench.startupEditor" = "none";
        "explorer.compactFolders" = false;
        "files.trimTrailingWhitespace" = true;
        "files.trimFinalNewlines" = true;
        "files.insertFinalNewline" = true;
        "diffEditor.ignoreTrimWhitespace" = false;
        "extensions.ignoreRecommendations" = true;
        "editor.selectionClipboard" = false;
        "C_Cpp.default.cppStandard" = "c++23";
      };

      keybindings = [
        {
          key = "ctrl+c";
          command = "workbench.action.terminal.copySelection";
          when = "terminalFocus && terminalProcessSupported && terminalTextSelected";
        }
        {
          key = "ctrl+v";
          command = "workbench.action.terminal.paste";
          when = "terminalFocus && terminalProcessSupported";
        }
      ];

    };

    home.file = {
      ".factorio".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/state/factorio";
    };

    home.stateVersion = "25.05";
  };

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
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ]; #localsend
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

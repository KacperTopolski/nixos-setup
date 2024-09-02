{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # services.avahi = {
  #   enable = true;
  #   nssmdns4 = true;
  #   openFirewall = true;
  # };

  # Printer
  services.printing.logLevel = "debug";
  services.printing.drivers = [
    (pkgs.pkgsi686Linux.callPackage ./driver.nix {}).driver
    (pkgs.callPackage ./driver.nix {}).cupswrapper 
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
}

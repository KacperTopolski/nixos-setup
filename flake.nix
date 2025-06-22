{
  inputs = {
    nixpkgs = {
        url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    fixed-gt = {
        url = "github:KacperTopolski/vte-ctrl-c-patch";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (import ./configuration.nix inputs)
      ];
    };
  };
}

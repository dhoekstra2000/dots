{
  description = "Home Manager configuration of douwe";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, nixos-hardware, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in
    {
      nixosConfigurations = {
        dlaptop = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ 
            nixos-hardware.nixosModules.lenovo-ideapad-16ach6
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.douwe = ./home.nix;
            }
          ];
        };
      };
      homeConfigurations = {
        "douwe" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          
          modules = [ ./home.nix ];
        };
      };
    };
}

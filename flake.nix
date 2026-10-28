{
  description = "Home Manager configuration of douwe";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in
      {
        nixosConfigurations = {
       	  ddesktop = lib.nixosSystem {
  	        system = "x86_64-linux";
  	        modules = [
    	        ./configuration.nix
  	        ];
	        };
        };
        homeConfigurations = {
          "douwe@desktop" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            
            modules = [ ./homes/desktop.nix ];
          };
          "douwe@uu" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            
            modules = [ ./homes/uu.nix ];
          };
        };
      };
}

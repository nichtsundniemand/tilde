{
  description = "Home Manager configuration of wirklichniemand";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, sops-nix, ... }:
    let
      system = "x86_64-linux";
    in {
      homeConfigurations."wirklichniemand" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        modules = [ ./home.nix ];
        extraSpecialArgs = { sops-nix = sops-nix; };
      };

      nixosModules.wirklichniemand = {config, lib, pkgs, utils, ...}: home-manager.nixosModule {
          inherit config lib pkgs utils;
          home-manager.users.wirklichniemand = import ./home.nix;
      };

      homeNix = import ./home.nix;
    };
}

{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
    # fenix = {
    #   url = "github:nix-community/fenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , nixpkgs-unstable
    , nixos-hardware
    , home-manager
    , fenix
    , nur
    , ...
    }: {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations = {
        hoshi = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hardware-configuration.nix
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.aya = import ./home.nix;
            }
          ]; # modules
        }; # hoshi
      };
    };
}

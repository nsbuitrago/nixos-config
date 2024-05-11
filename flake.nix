
# N N         NB B B B B B
# N  N        NB         B
# N   N       NB         B
# N    N      NB         B
# N     N     NB B B B B B
# N      N    NB         B
# N       N   NB         B
# N        N  NB         B
# N         N NB B B B B B

{
  description = "NSBuitrago's NixOS/Darwin Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    ...
  } @ inputs: let
    inherit (self) outputs;
    nsbUser = "nsbuitrago";
    chillweiUser = "chillwei";
  in {

    nixosConfigurations = {
      odinson = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs nsbUser chillweiUser;};
        modules = [./linux/odinson/configuration.nix];
      };
    };

    homeConfigurations = {
      "${nsbUser}@odinson" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs nsbUser;};
        modules = [./users/nsbuitrago/home.nix];
      };

      "${chillweiUser}@odinson" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs chillweiUser;};
        modules = [./users/chillwei/home.nix];
      };
    };

    darwinConfigurations = {
      "${nsbUser}@hodgkin" = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs nsbUser;};
        modules = [./darwin/hodgkin.nix];
      };
      }
    }
  };
}

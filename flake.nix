{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nix-darwin, self, ... }: {
    # $ darwin-rebuild build --flake .#Tobys-MacBook-Pro
    darwinConfigurations."Tobys-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      # Need this to pass inputs to modules/darwin
      specialArgs = { inherit inputs; };

      modules = [
        ./modules/darwin

        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.toby.imports = [ ./modules/home-manager ];
          home-manager.backupFileExtension = "backup";
        }
      ];
    };

    # $ darwin-rebuild build --flake .#Tobys-MacBook-Air
    darwinConfigurations."Tobys-MacBook-Air" = nix-darwin.lib.darwinSystem {
      # Need this to pass inputs to modules/darwin
      specialArgs = { inherit inputs; };

      modules = [
        # TODO: Reorganise modules
        ./modules/darwin

        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.toby.imports = [ ./modules/home-manager ];
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}

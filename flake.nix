{
  description = "Toby's nix-darwin config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nix-darwin, self, ... }: {
    # Build darwin flake using:
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
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Tobys-MacBook-Pro".pkgs;
  };
}

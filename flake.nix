# -----------------------------------------------------------------------------
# Defines this repository as a Nix flake and serves as the entry point for the
# entire configuration. It declares the external dependencies, sets the user
# and machine configuration, and connects the system-level configuration
# (configuration.nix) with the user-level configuration (home.nix).
# -----------------------------------------------------------------------------

{
  description = "dotfiles";

  inputs = {
    # Defines the external projects this configuration depends on.

    # Provides the Nix package collection used throughout the configuration.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    # Provides nix-darwin, which applies declarative macOS system settings.
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Provides Home Manager for user-level configuration.
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Lets Homebrew be managed declaratively through nix-darwin.
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  # Builds the outputs defined by this flake.
  outputs = inputs@{ self, nix-darwin, nix-homebrew, home-manager, nixpkgs }:

    let
      # Stores the macOS username used throughout the configuration.
      user = "atticusmcnulty";
    in
    {
      # Defines the macOS system named "mac".
      #
      # The host name here must match the name used by bootstrap.sh and
      # rebuild.sh when they run darwin-rebuild.
      darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {

        # Makes the username available to imported configuration files.
        specialArgs = { inherit user; };

        # Combines the system configuration with Home Manager and Homebrew.
        modules = [
          ./configuration.nix

          # Enables declarative Homebrew management.
          nix-homebrew.darwinModules.nix-homebrew

          # Enables Home Manager.
          home-manager.darwinModules.home-manager

          {
            # Makes Home Manager use the same package set as the system.
            home-manager.useGlobalPkgs = true;

            # Installs Home Manager packages into the user's environment.
            home-manager.useUserPackages = true;

            # Passes the username into home.nix.
            home-manager.extraSpecialArgs = { inherit user; };

            # Loads the user's Home Manager configuration.
            home-manager.users.${user} = import ./home.nix;
          }
        ];
      };
    };
}
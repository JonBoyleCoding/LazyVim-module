{
  description = "Home Manager module for LazyVim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    systems.url = "github:nix-systems/default-linux";
  };

  outputs =
    {
      nixpkgs,
      self,
      systems,
      ...
    }:
    {
      homeManagerModules = {
        default = self.homeManagerModules.lazyvim;
        lazyvim = import ./lazyvim self;
      };

      packages = nixpkgs.lib.genAttrs (import systems) (
        system:
        let
          inherit (import nixpkgs { inherit system; }) callPackage;
        in
        {
          astro-ts-plugin = callPackage ./pkgs/astro-ts-plugin { };
          typescript-svelte-plugin = callPackage ./pkgs/typescript-svelte-plugin { };
          vtsls = callPackage ./pkgs/vtsls { };
        }
      );
    };
}

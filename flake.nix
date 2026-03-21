{
  description = "Flake for dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { self, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [ inputs.nixvim.flakeModules.default ];

      nixvim = {
        packages.enable = true;
        checks.enable = true;
      };

      flake = {
        nixvimModules.default = ./modules;
        lib.mkNvim =
          { system, languages }:
          inputs.nixvim.lib.evalNixvim {
            inherit system;
            modules = [
              self.nixvimModules.default
              { languages = languages; }
            ];
          };
      };

      perSystem =
        { system, self', ... }:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
        in
        {
          nixvimConfigurations.default = inputs.nixvim.lib.evalNixvim {
            inherit system;
            modules = [
              self.nixvimModules.default
              { languages.nix.enable = true; }
            ];
          };

          devShells.default = pkgs.mkShell {
            shellHook = "exec fish";
            buildInputs = [ self'.packages.default ];
          };

          formatter = pkgs.nixfmt;
        };
    };
}

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
        "aarch64-darwin"
      ];

      flake.lib.mkNvim =
        { system, languages }:
        inputs.nixvim.lib.evalNixvim {
          inherit system;
          modules = [
            ./modules
            { languages = languages; }
          ];
        };

      perSystem =
        { system, self', ... }:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          nvim = inputs.nixvim.lib.evalNixvim {
            inherit system;
            modules = [
              ./modules
              { languages.nix.enable = true; }
            ];
          };
        in
        {
          packages.default = nvim.config.build.package;
          checks.default = nvim.config.build.test;

          devShells.default = pkgs.mkShell {
            shellHook = "exec fish";
            buildInputs = [ self'.packages.default ];
          };

          formatter = pkgs.nixfmt;
        };
    };
}

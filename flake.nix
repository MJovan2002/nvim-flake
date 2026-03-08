{
  description = "Flake for dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      nixvim,
      ...
    }:
    let
      mkNvim =
        {
          pkgs,
          languages,
        }:
        nixvim.legacyPackages."${pkgs.stdenv.hostPlatform.system}".makeNixvimWithModule {
          inherit pkgs;
          module = ./modules;
          extraSpecialArgs = {
            inherit languages;
          };
        };
      defaultNvim =
        pkgs:
        mkNvim {
          inherit pkgs;
          languages.nix = true;
        };
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = defaultNvim pkgs;
        mkNvim = { languages }: mkNvim { inherit pkgs languages; };
        devShells.default = pkgs.mkShell {
          shellHook = "exec fish";
          buildInputs = [ (defaultNvim pkgs) ];
        };
        formatter = pkgs.nixfmt;
      }
    );
}

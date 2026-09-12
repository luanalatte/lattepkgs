{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake = {
        overlays.default = final: _: import ./default.nix { pkgs = final; };
      };

      perSystem = { pkgs, ... }: {
        packages = import ./default.nix { inherit pkgs; };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nix-update
          ];
        };
      };
    };
}

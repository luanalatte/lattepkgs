{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f (
            import nixpkgs {
              inherit system;
            }
          )
        );
    in
    {
      packages = forAllSystems (pkgs: import ./default.nix { inherit pkgs; });
      overlays.default = final: prev: import ./default.nix { pkgs = final; };

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.nix-update
          ];
        };
      });
    };
}

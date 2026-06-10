{
  pkgs ? import <nixpkgs> { },
}:

{
  laravel = pkgs.callPackage ./pkgs/laravel/package.nix { };
}

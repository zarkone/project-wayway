
{
  description = "wlroots";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-compat = {
    url = github:edolstra/flake-compat;
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, nixpkgs-wayland, ... }:
    flake-utils.lib.eachDefaultSystem (system: let

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      # NB add `extra-platforms = x86_64-darwin aarch64-darwin` to your nix.extraOptions on m1
      x86-darwin-pkgs = import nixpkgs {
        system = "x86_64-darwin";
        config = { allowUnfree = true; };
      };
    in {
      devShell = pkgs.mkShell {
        name = "wlroots";
        WAYLAND_PROTOCOLS = "${nixpkgs-wayland.packages.${system}.wayland-protocols-master}/share/wayland-protocols";
        nativeBuildInputs = [
          nixpkgs-wayland.packages.${system}.wlroots
          nixpkgs-wayland.packages.${system}.wayland-protocols-master
          pkgs.pkg-config
          pkgs.wayland
          pkgs.libxkbcommon
          pkgs.libudev
          pkgs.pixman
        ];
      };
    });
}

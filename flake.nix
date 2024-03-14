{
  description = "Application packaged using poetry2nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    poetry2nix,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      # see https://github.com/nix-community/poetry2nix/tree/master#api for more functions and examples.
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (poetry2nix.lib.mkPoetry2Nix {inherit pkgs;}) mkPoetryApplication;
    in {
      packages = rec {
        myapp = mkPoetryApplication {projectDir = self;};
        default = self.packages.${system}.myapp;
        docker = pkgs.dockerTools.buildImage {
          name = "app";
          tag = "0.1.0";
          created = "now";
          config = {
            Cmd = ["${myapp}/bin/app"];
          };
        };
      };

      devShells.default = pkgs.mkShell {
        inputsFrom = [self.packages.${system}.myapp];
        packages = [pkgs.poetry];
      };
    });
}

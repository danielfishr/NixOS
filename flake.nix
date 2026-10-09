{
  description = "Dan's NixOS configurations";

  inputs = {
    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { codex-desktop-linux, nixpkgs, ... }:
    let
      mkHost = system: configuration: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ configuration ];
        specialArgs = { inherit codex-desktop-linux; };
      };
    in {
      nixosConfigurations = {
        utm-on-mac14 = mkHost "aarch64-linux" ./hosts/utm-on-mac14/configuration.nix;
        g14 = mkHost "x86_64-linux" ./hosts/g14/configuration.nix;
      };
    };
}

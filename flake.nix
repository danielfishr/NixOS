{
  description = "Dan's NixOS configurations";

  inputs = {
    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # Independent pins: updating one browser does not update the system or the other.
    chromium-nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    librewolf-nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { codex-desktop-linux, nixpkgs, chromium-nixpkgs, librewolf-nixpkgs, ... }:
    let
      mkHost = system: configuration: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ configuration ];
        specialArgs = {
          inherit codex-desktop-linux;
          browserPackages = {
            chromium = chromium-nixpkgs.legacyPackages.${system}.chromium;
            librewolf = librewolf-nixpkgs.legacyPackages.${system}.librewolf;
          };
        };
      };
    in {
      nixosConfigurations = {
        utm-on-mac14 = mkHost "aarch64-linux" ./hosts/utm-on-mac14/configuration.nix;
        g14 = mkHost "x86_64-linux" ./hosts/g14/configuration.nix;
      };
    };
}

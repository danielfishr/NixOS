{
  description = "Dan's NixOS configurations";

  inputs = {
    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { codex-desktop-linux, nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ ./hosts/nixos/configuration.nix ];
      specialArgs = { inherit codex-desktop-linux; };
    };
  };
}

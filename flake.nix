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
    nixosConfigurations.utm-on-mac14 = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ ./hosts/utm-on-mac14/configuration.nix ];
      specialArgs = { inherit codex-desktop-linux; };
    };
  };
}

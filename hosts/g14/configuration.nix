{ ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
    ./laptop.nix
  ];

  networking.hostName = "g14";
  environment.etc."hypr/host.lua".text = builtins.readFile ./hyprland.lua;
}

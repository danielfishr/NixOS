{ pkgs, ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
    ./laptop.nix
  ];

  networking.hostName = "g14";

  programs = {
    steam = {
      # Install Steam and its NixOS integration only on the gaming laptop.
      enable = true;
      # Provide TrueType font fallbacks inside Steam's runtime.
      fontPackages = with pkgs; [ liberation_ttf corefonts noto-fonts ];
      # Add a Gamescope session for games that benefit from a nested compositor.
      gamescopeSession.enable = true;
    };
    # Let games request temporary CPU scheduler and power-management tuning.
    gamemode.enable = true;
  };

  hardware = {
    # Add Steam controller and common gaming-device udev rules.
    steam-hardware.enable = true;
    # Improve Xbox One and Series controller support over Bluetooth.
    xpadneo.enable = true;
    # Support Xbox One and Series controllers via the Microsoft USB wireless adapter.
    xone.enable = true;
    # Enable Bluetooth for wireless controllers such as Xbox and 8BitDo pads.
    bluetooth.enable = true;
    # Power Bluetooth on at boot so controllers can reconnect without extra setup.
    bluetooth.powerOnBoot = true;
  };

  # Provide a graphical Bluetooth pairing tool for controllers.
  services.blueman.enable = true;
  environment.etc."hypr/host.lua".text = builtins.readFile ./hyprland.lua;
}

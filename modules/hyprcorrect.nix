{ pkgs, ... }:

let
  hyprcorrect = pkgs.callPackage ../packages/hyprcorrect.nix { };
  hyprcorrectSession = pkgs.writeShellApplication {
    name = "hyprcorrect-session";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      config_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/hyprcorrect"
      install -d -m700 "$config_dir"
      # HyprCorrect requires a user-owned regular file, not a Nix store symlink.
      install -m600 /etc/hyprcorrect/config.toml "$config_dir/config.toml"
      exec ${hyprcorrect}/bin/hyprcorrect
    '';
  };
in
{
  environment.systemPackages = [ hyprcorrect hyprcorrectSession ];
  environment.etc."hyprcorrect/config.toml".source = ../config/hyprcorrect/config.toml;

  # The evdev backend needs keyboard access; membership takes effect at login.
  users.users.dan.extraGroups = [ "input" ];
}

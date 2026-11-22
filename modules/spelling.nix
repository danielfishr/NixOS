{ pkgs, ... }:

let
  aspell = pkgs.aspellWithDicts (dicts: [ dicts.en ]);
  spellingSuggestions = pkgs.writeShellApplication {
    name = "spelling-suggestions";
    runtimeInputs = [ aspell pkgs.python3 pkgs.rofi pkgs.wl-clipboard pkgs.libnotify pkgs.hyprland ];
    text = ''
      exec python3 ${../config/spelling/suggestions.py}
    '';
  };
in
{
  environment.systemPackages = [ aspell pkgs.rofi spellingSuggestions ];
  environment.etc."aspell.conf".text = ''
    lang en_GB
  '';
}

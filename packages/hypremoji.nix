{ lib, rustPlatform, fetchFromGitHub, pkg-config, gtk4, wrapGAppsHook4, makeWrapper, wl-clipboard, hyprland }:

rustPlatform.buildRustPackage {
  pname = "hypremoji";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "Musagy";
    repo = "hypremoji";
    rev = "745a22ad141e4652780c2a8f3a3b495e011a8f40";
    hash = "sha256-Hvb5nsJOP+Cu2pRkP/BfN0O6BSWBcnNMH2CTLQtn6D8=";
  };

  cargoLock.lockFile = ./hypremoji-Cargo.lock;
  postUnpack = ''
    cp ${./hypremoji-Cargo.lock} "$sourceRoot/Cargo.lock"
  '';
  nativeBuildInputs = [ pkg-config wrapGAppsHook4 makeWrapper ];
  buildInputs = [ gtk4 ];

  postInstall = ''
    cp -r assets "$out/assets"
    cp config/{config.json,hypremoji.conf,hypremoji.lua} "$out/"
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ wl-clipboard hyprland ]})
  '';

  meta = {
    description = "Emoji picker for Hyprland";
    homepage = "https://github.com/Musagy/hypremoji";
    license = lib.licenses.isc;
    mainProgram = "hypremoji";
    platforms = lib.platforms.linux;
  };
}

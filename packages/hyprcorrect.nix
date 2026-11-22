{ lib, stdenv, fetchurl, autoPatchelfHook, makeWrapper, fontconfig, freetype
, libglvnd, libxkbcommon, wayland, libx11, libxcursor, libxi, libxrandr
, hyprland, libnotify, wl-clipboard, wtype
}:

stdenv.mkDerivation rec {
  pname = "hyprcorrect";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/jondkinney/hyprcorrect/releases/download/v${version}/hyprcorrect-${version}-x86_64.tar.gz";
    hash = "sha256-D/t6w2bG3rfNkq0ODPjnqQ0jcGfNFZtL3AdCrjPuOB8=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [ libxkbcommon stdenv.cc.cc.lib ];
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 hyprcorrect "$out/bin/hyprcorrect"
    install -Dm644 hyprcorrect.desktop "$out/share/applications/hyprcorrect.desktop"
    mkdir -p "$out/share/icons" "$out/share/licenses/hyprcorrect"
    cp -r icons/hicolor "$out/share/icons/"
    cp LICENSE-MIT LICENSE-APACHE "$out/share/licenses/hyprcorrect/"
    runHook postInstall
  '';

  # egui loads the window-system and graphics libraries at runtime.
  postFixup = ''
    wrapProgram "$out/bin/hyprcorrect" \
      --prefix PATH : ${lib.makeBinPath [ hyprland libnotify wl-clipboard wtype ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        fontconfig freetype libglvnd libxkbcommon wayland
        libx11 libxcursor libxi libxrandr
      ]}
  '';

  meta = {
    description = "Keyboard-driven desktop spelling and typo correction";
    homepage = "https://github.com/jondkinney/hyprcorrect";
    license = with lib.licenses; [ mit asl20 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "hyprcorrect";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}

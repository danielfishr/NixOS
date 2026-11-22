{ curl, fetchurl, jetbrains, libsecret, stdenv }:

let
  version = "2026.3.0.1";
  sources = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
      hash = "sha256-MPvT4Ac8WHzbMclJcWAWn2ncgzuVAGt4fYsVWeNDDao=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}-aarch64.tar.gz";
      hash = "sha256-bqa3XTaQmbZ9VXjkjG3HBvmNhk9cgN+9IPdN8if94Xs=";
    };
  };
in
# Keep Nixpkgs' launchers, native-library patches and .NET runtime integration.
jetbrains.rider.overrideAttrs (previous: {
  inherit version;
  src = fetchurl sources.${stdenv.hostPlatform.system};
  buildInputs = previous.buildInputs ++ [ curl libsecret ];
  autoPatchelfIgnoreMissingDeps = (previous.autoPatchelfIgnoreMissingDeps or []) ++ [
    # Optional MSAL broker: WebKitGTK 4.0 was removed from this Nixpkgs pin.
    "libwebkit2gtk-4.0.so.37"
    "libjavascriptcoregtk-4.0.so.18"
    "libsoup-2.4.so.1"
    # The bundled Android debugger agent runs on the device, not the host.
    "liblog.so"
  ];
  passthru = previous.passthru // {
    buildNumber = "263.7307.325";
  };
})

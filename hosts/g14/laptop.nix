{ lib, ... }:

{
  # ASUS ROG Zephyrus G14 GA401QM (2021), Ryzen + RTX 3060.
  # Model settings follow nixos-hardware/asus/zephyrus/ga401.
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [ "amd_pstate=active" ];

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      dynamicBoost.enable = true;
      prime = {
        # Verified against this laptop's PCI devices.
        amdgpuBusId = "PCI:4:0:0";
        nvidiaBusId = "PCI:1:0:0";
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
  };

  services = {
    xserver.videoDrivers = [ "amdgpu" "nvidia" ];
    asusd.enable = true;
    fstrim.enable = lib.mkDefault true;
    power-profiles-daemon.enable = true;
    udev.extraHwdb = ''
      evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*GA401QM*:*
       KEYBOARD_KEY_ff31007c=f20
       KEYBOARD_KEY_ff3100b2=home
       KEYBOARD_KEY_ff3100b3=end
    '';
  };
}

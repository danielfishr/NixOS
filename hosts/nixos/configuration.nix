{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/London";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  console.keyMap = "uk";

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    xserver = {
      enable = true;
      xkb = {
        layout = "gb";
        variant = "";
      };
    };

    printing.enable = true;
    pulseaudio.enable = false;
    spice-vdagentd.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security.rtkit.enable = true;

  users.users.dan = {
    isNormalUser = true;
    description = "dan";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs = {
    firefox.enable = true;
    zsh.enable = true;

    neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      configure = {
        customLuaRC = ''
          ${builtins.readFile ../../examples/nvim/init.lua}

          local config_dir = vim.fn.stdpath("config")
          local init_lua = config_dir .. "/init.lua"
          local init_vim = config_dir .. "/init.vim"

          if vim.fn.filereadable(init_lua) == 1 then
            dofile(init_lua)
          elseif vim.fn.filereadable(init_vim) == 1 then
            vim.cmd.source(vim.fn.fnameescape(init_vim))
          end
        '';
        packages.default.start = with pkgs.vimPlugins; [
          fzf-lua
          nvim-tree-lua
          nvim-web-devicons
          which-key-nvim
        ];
      };
    };
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.etc."xdg/kitty/kitty.conf".text = ''
    font_family JetBrainsMono Nerd Font
    font_size 12.0
  '';

  environment.systemPackages = with pkgs; [
    dotnet-sdk_10
    fzf
    git
    kitty
    nodejs_24
    ripgrep
    tree
    tree-sitter
    vscode
    wl-clipboard
  ];

  system.stateVersion = "26.05";
}

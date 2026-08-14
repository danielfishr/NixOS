{ codex-desktop-linux, pkgs, ... }:

let
  napNvim = pkgs.vimUtils.buildVimPlugin {
    pname = "nap.nvim";
    version = "98037cff";
    src = builtins.fetchGit {
      url = "https://github.com/liangxianzhe/nap.nvim";
      rev = "98037cff509a12412cf8f32d1b12a9fdcad558ad";
    };
  };
in

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "utm-on-mac14";
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
    displayManager.gdm.enable = false;
    desktopManager.gnome.enable = false;

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
    hyprland.enable = true;
    zsh.enable = true;

    neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      configure = {
        customLuaRC = ''
          ${builtins.readFile ../../config/nvim/init.lua}

          local config_dir = vim.fn.stdpath("config")
          local init_lua = config_dir .. "/init.lua"
          local init_vim = config_dir .. "/init.vim"

          if vim.fn.filereadable(init_lua) == 1 then
            dofile(init_lua)
          elseif vim.fn.filereadable(init_vim) == 1 then
            vim.cmd.source(vim.fn.fnameescape(init_vim))
          end
        '';
        packages.default.start =
          (with pkgs.vimPlugins; [
            blink-cmp
            codecompanion-nvim
            conform-nvim
            copilot-lua
            dracula-nvim
            fzf-lua
            gitsigns-nvim
            lualine-nvim
            marks-nvim
            mason-lspconfig-nvim
            mason-nvim
            mini-align
            mini-indentscope
            mini-move
            mini-splitjoin
            noice-nvim
            nui-nvim
            nvim-lspconfig
            nvim-notify
            nvim-surround
            nvim-tree-lua
            nvim-treesitter
            nvim-treesitter-context
            nvim-treesitter-textobjects
            nvim-web-devicons
            plenary-nvim
            render-markdown-nvim
            rose-pine
            vim-floaterm
            which-key-nvim
            yanky-nvim
          ])
          ++ [ napNvim ];
      };
    };
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.etc."hypr/hyprland.lua".text = ''
    ${builtins.readFile ./hyprland.lua}
    ${builtins.readFile ../../config/hypr/hyprland.lua}
  '';

  systemd.tmpfiles.rules = [
    "d /home/dan/.config 0755 dan users -"
    "d /home/dan/.config/hypr 0755 dan users -"
    "L /home/dan/.config/hypr/hyprland.lua - - - - /etc/hypr/hyprland.lua"
  ];

  environment.etc."xdg/kitty/kitty.conf".text = ''
    font_family JetBrainsMono Nerd Font
    font_size 11.0
  '';

  environment.systemPackages = with pkgs; [
    brightnessctl
    codex
    codex-desktop-linux.packages.${pkgs.stdenv.hostPlatform.system}.default
    csharp-ls
    dotnet-sdk_10
    fzf
    fuzzel
    git
    grim
    kitty
    ltex-ls-plus
    lua-language-server
    mako
    nodejs_24
    playerctl
    pyright
    python3
    ripgrep
    rust-analyzer
    slurp
    tree
    tree-sitter
    typescript-language-server
    typos-lsp
    vscode
    vscode-langservers-extracted
    waybar
    wdisplays
    wl-clipboard
    yaml-language-server
  ];

  system.stateVersion = "26.05";
}

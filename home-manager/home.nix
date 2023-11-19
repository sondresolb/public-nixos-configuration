# Home-manager configuration file
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    overlays = [
      # Define inline overlays or use from other flakes
    ];
    # Configure nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "sondre";
    homeDirectory = "/home/sondre";
  };

  # Enable neovim module
  programs.neovim.enable = true;

  # User packages
  home.packages = with pkgs; [
    # File manager
    lf
    # Screenshot utilities
    grim
    slurp
    swappy
    # Clipboard utility
    wl-clipboard
    # Generate ascii headers
    figlet
  ];

  # Configure hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = import ./hyprland/config.nix {};
    xwayland.enable = true;
  };

  # Configure bash 
  programs.bash = {
    enable = true;
    shellAliases = {
      home-switch = "home-manager switch --flake ~/Flakes/nixos-configuration/#sondre@laptop";
    };
  };
 
  # Configure git
  programs.git = {
    enable = true;
    userName = "Sondre Solbakken";
    userEmail = "person@example.com";
    ignores = [
      ".ijwb"
      ".idea"
      "*.pyc"
      ".python-version"
      "__pycache__/"
      ".venv"
      "venv/"
      "target"
      "coverage_html"
      "__debug_bin"
      "traces.txt"
      ".vscode"
      ".env"
    ];
    delta = {
      enable = true;
      options = {
        side-by-side = true;
	line-numbers = true;
      };
    };
  };

  # Manage dotfiles
  home.file = {
    ".config/swappy/config".text = ''
        [Default]
        save_dir=$HOME/Pictures
        save_filename_format=screenshot-%Y%m%d-%H%M%S.png
        show_panel=false
        line_size=5
        text_size=20
        text_font=sans-serif
        paint_mode=brush
        early_exit=true
        fill_shape=false
    '';
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Enable home-manager
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

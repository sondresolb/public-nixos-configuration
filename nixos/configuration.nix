# System configuration file
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Import generated hardware configuration
    ./hardware-configuration.nix
    
    # Split up configuration and import pieces of it:
    # ./users.nix
  ];

  nixpkgs = {
    overlays = [
      # Inline overlays or from other flakes
    ];
    # Configure nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Networking
  networking.hostName = "laptop";
  networking.networkmanager.enable = true;

  # Time zone, locale and keymap
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "no";
  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # User settings (system-wide)
  users.users = {
    sondre = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # Add SSH public key(s) here
      ];
      # User groups
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };
 
  # Display manager
  services.xserver = {
    enable = true;
    layout = "no";
    excludePackages = [ pkgs.xterm ];
    displayManager = {
      sddm.enable = true;
      sddm.theme = "${import ./derivations/sddm-astronaut-theme.nix { inherit pkgs; }}";
      defaultSession = "hyprland";
    };
  };

  # Enable hyprland (managed by hm)
  programs.hyprland = {
    enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Browser
    firefox
    # Fetching utilities
    curl
    wget
    # System info
    neofetch
    # Terminal emulator
    kitty
    # Desktop bar
    waybar
    # Graphical network manager
    networkmanagerapplet
    # Notification daemon
    dunst
    libnotify
    # Wallpaper daemon
    hyprpaper
    # App launcher
    rofi-wayland
    # Required by sddm-atronaut-theme
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtsvg
  ];

  # System fonts
  fonts.packages = with pkgs; [
    # Fonts required by sddm-astronaut-theme
    (callPackage ./derivations/sddm-astronaut-fonts.nix { inherit pkgs; })
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

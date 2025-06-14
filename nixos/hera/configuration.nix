# DON'T EDIT THIS FILE IN /etc/nixos/configuration.nix
# EDIT THIS from github.com/allisonsierra/nixos-configuration
# AND DEPLOY VIA `just deploy-nixos porter`
#
# Acer Laptop "Hera"
# Hybrid Nvidia/Intel Optimus GPU - Quadro RTX 4000
#
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hera"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Keyring
  security.pam.services.lightdm.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.allie = {
    isNormalUser = true;
    description = "Allie Sierra";
    extraGroups = [
      "networkmanager"
      "wheel"
      "mlocate"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # zsh
  programs.zsh.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # System
    vim
    cifs-utils
    wget
    curl
    htop
    rclone
    lshw
    gnome-keyring

    # Display
    autorandr
    arandr
    mons
    pkgs.nvtopPackages.nvidia

    # Dev
    git
    rustup
    obsidian
    inkscape-with-extensions
    krita
    direnv
    starship
    okular

    (vscode-with-extensions.override {
      vscodeExtensions =
        with vscode-extensions;
        [
          bbenoist.nix
          mkhl.direnv
          github.vscode-github-actions
          github.vscode-pull-request-github
          golang.go
          hashicorp.terraform
          rust-lang.rust-analyzer
          tamasfe.even-better-toml
          skellock.just
          davidanson.vscode-markdownlint
          usernamehw.errorlens
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "rustowl-vscode";
            publisher = "cordx56";
            version = "0.1.3";
            sha256 = "1z90in9kf3xh8bgsk678k22vnz86i7mfy4ckph915m37rpim7243";
          }
        ];
    })

    # Media
    vdhcoapp # Video Downloadhelper for FF Extension
    vlc
    mpv
    spotify

    # Communication
    discord
    zoom-us

  ];

  # Fonts
  fonts.packages = with pkgs; [
    montserrat
    nerdfonts
    fira-code
    fira-code-symbols
    noto-fonts
    noto-fonts-cjk-sans
    liberation_ttf

  ];

  # Nix Configuration
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # List services that you want to enable:
  services.locate.enable = true;

  # Corsair Keyboard
  hardware.ckb-next.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}

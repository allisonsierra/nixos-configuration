# DON'T EDIT THIS FILE IN /etc/nixos/configuration.nix
# EDIT THIS from github.com/allisonsierra/nixos-configuration
# AND DEPLOY VIA `just deploy-nixos ajax`
#
# NOTE: This file ignores /etc/nixos/hardware-configuration.nix. Move 
# those configurations to this file.
#
# Gaming Rig "Ajax"
#
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [ "amd_pstate=guided" ];

  boot.initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
  boot.extraModprobeConfig = "options bluetooth disable_ertm=Y amdgpu ppfeaturemask=0xffffffff";

  # Networking
  networking.hostName = "ajax"; 
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # networking.interfaces.wlp13s0.useDHCP = lib.mkDefault true;
  
  networking.useDHCP = false;
  networking.bridges = {
    "br0" = {
      interfaces = [ "enp14s0" ];
    };
  };
  networking.interfaces.br0.ipv4.addresses = [ {
    address = "172.16.1.45";
    prefixLength = 24;
  } ];
  networking.defaultGateway = "172.16.1.1";
  networking.nameservers = ["127.0.0.1" "4.2.2.2" "8.8.8.8"];

  # Local DNS caching
  services.coredns.enable = true;
  services.coredns.config =
  ''
    . {
      # Cloudflare and Google
      forward . 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
      cache
    }

    # Returns 127.0.0.1 for any .local address
    # TODO: 
    # local {
    #   template IN A  {
    #       answer "{{ .Name }} 0 IN A 127.0.0.1"
    #   }
    }
  '';


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
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # See https://nixos.wiki/wiki/Nvidia for details on the config below

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  # Enable CUPS to print documents.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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
        "libvirtd"
        "media"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  thunderbird
    ];
    
  };

  users.groups.media.gid = 948;

  # zsh
  programs.zsh.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Virtualization
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = [ pkgs.virtiofsd ]; # Share disk between host and guest
    };
  };

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
    via
    file-roller
    p7zip
    keepass
    sysbench
    openrgb-with-all-plugins
    chromium
    dnsutils
    mangohud
    mission-center

    # Disk usage analyzers
    baobab
    qdirstat

    # Windows support
    wineWowPackages.stable
    winetricks

    # Display
    autorandr
    arandr
    mons
    radeontop
    lact
    amdgpu_top

    # Gaming
    steamtinkerlaunch # https://github.com/LucaPisl/LinuxModdingGuide
    limo
    protontricks

    # Dev
    git
    rustup
    obsidian
    inkscape-with-extensions
    krita
    direnv
    starship
    kdePackages.okular

    # Music
    lmms
    ardour
    vital
    infamousPlugins
    lsp-plugins
    x42-avldrums
    #vcv-rack

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
    signal-desktop
  ];

  # Fonts
  fonts.packages = with pkgs; [
    montserrat
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.hack
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
  ];

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      experimental = true; # show battery

      # https://www.reddit.com/r/NixOS/comments/1ch5d2p/comment/lkbabax/
      # for pairing bluetooth controller
      Privacy = "device";
      JustWorksRepairing = "always";
      Class = "0x000100";
      FastConnectable = true;
    };
  };

  services.blueman.enable = true;

  hardware.xpadneo.enable = true; # Enable the xpadneo driver for Xbox One wireless controllers



  # Nix Configuration
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # List services that you want to enable:
  services.locate.enable = true;

  # Corsair RGB Management
  services.hardware.openrgb.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  

  # Filesystems
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/188e2f2e-ae22-40b6-80f2-89b4d953b1ba";
      fsType = "ext4";
    };

  fileSystems."/games" =
    { device = "/dev/disk/by-uuid/aa945901-50ba-455f-8b1a-3cb13af46693";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/60D4-430E";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/mount/media01" =
    { device = "/dev/disk/by-uuid/2b62aa5a-f95a-4de6-82f6-2561d42b09cd";
      fsType = "ext4";
    };

  fileSystems."/mount/media02" =
    { device = "/dev/disk/by-uuid/ebea71ad-d3a8-434a-bb02-abe13862d550";
      fsType = "ext4";
    };

  fileSystems."/mount/data01" =
    { device = "/dev/disk/by-uuid/65987a3d-f097-4612-9092-3db0591b9ffd";
      fsType = "ext4";
    };

  fileSystems."/mount/data02" =
    { device = "/dev/disk/by-uuid/8a3ca63a-a06a-4d75-a513-6dee778a85a2";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/de4a1080-a8ec-4593-9429-d04b615c31f6"; }
    ];


  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

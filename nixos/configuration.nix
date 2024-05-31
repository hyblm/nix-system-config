# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "i915.force_probe=*" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_5_19;

  networking.hostName = "carbon"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Prague";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  services.upower.enable = true;
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "intel" ];
    deviceSection = '' Option "DRI" "2" '';

  libinput.enable = true;
  displayManager.gdm.enable = true;

  xkb.extraLayouts.canary = {
          description = "English ergonomic layout evolution of colemak";
          languages   = [ "eng" ];
          symbolsFile = /home/matyas/.config/symbols/canary;
      };
  xkb.extraLayouts.recurva = {
          description = "An alternative keyboard layout focused on efficiency";
          languages   = [ "eng" ];
          symbolsFile = /home/matyas/.config/symbols/recurva;
      };
  xkb.layout = "recurva,us,cz";
  xkb.variant = ",,qwerty";

  };
  # nixpkgs.config = {
  #   packageOverrides = super: rec {
  #           xorg = super.xorg // rec {
  #                   xkeyboardconfig_rofl = super.xorg.xkeyboardconfig.overrideAttrs (old: {
  #                           patches = [
  #                               (builtins.toFile "hyperroll" ''
  #                                   Index: xkeyboard-config-2.17/symbols/us
  #                                   ========================================================
  #                               '')
  #                           ]
  #                       })
  #               }
  #       }
  # };
  services.zerotierone = {
    enable = true;
    port = 9993;
    joinNetworks = [
      "9bee8941b57ddfe0"
    ];
  };
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };


  hardware.keyboard.qmk.enable = true;
  # Xremap
  hardware.uinput.enable = true;
  users.groups.uinput.members = [ "matyas" ];
  users.groups.input.members = [ "matyas" ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.cnijfilter2 pkgs.cnijfilter_2_80 ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
      # intel-media-driver
      # vaapiIntel
      # vaapiVdpau
      # libvdpau-va-gl
      # vulkan-validation-layers
      
      xorg.xf86videointel
    ];
  };
# hardware = {
#   opengl =
#     let
#       fn = oa: {
#         nativeBuildInputs = oa.nativeBuildInputs ++ [ pkgs.glslang ];
#         mesonFlags = oa.mesonFlags ++ [ "-Dvulkan-layers=device-select,overlay" ];
# #       patches = oa.patches ++ [ ./mesa-vulkan-layer-nvidia.patch ]; See below 
#         postInstall = oa.postInstall + ''
#             mv $out/lib/libVkLayer* $drivers/lib

#             #Device Select layer
#             layer=VkLayer_MESA_device_select
#             substituteInPlace $drivers/share/vulkan/implicit_layer.d/''${layer}.json \
#               --replace "lib''${layer}" "$drivers/lib/lib''${layer}"

#             #Overlay layer
#             layer=VkLayer_MESA_overlay
#             substituteInPlace $drivers/share/vulkan/explicit_layer.d/''${layer}.json \
#               --replace "lib''${layer}" "$drivers/lib/lib''${layer}"
#           '';
#       };
#     in
#     with pkgs; {
#       enable = true;
#       driSupport32Bit = true;
#       package = (mesa.overrideAttrs fn).drivers;
#       package32 = (pkgsi686Linux.mesa.overrideAttrs fn).drivers;
#     };
#   };
  
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Enable touchpad support (enabled default in most desktopManager).

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    work-sans
    fira-code-symbols
    (nerdfonts.override { fonts = ["JetBrainsMono"]; })
    recursive
    ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.matyas = {
    isNormalUser = true;
    description = "matyas";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
     obsidian
     todoist-electron
     hyprland
    corefonts
    vistafonts
    ];
  };

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  environment.systemPackages = with pkgs; [
    driversi686Linux.mesa
    system-config-printer
    exiftool
    gcc
    # unstable.python3
    glib
    glibc
    glibc_multi
    sassc
    ripgrep

    udiskie

    distrobox
    file
    mesa
    mesa.drivers
    vulkan-tools
    vulkan-loader

    appimage-run

    home-manager
  ];

  programs.hyprland.enable = true;
  programs.thunar.enable = true;
  programs.steam.enable = true;
  programs.nix-ld = {
    enable = true;
    # libraries = with pkgs; [ ];
  };

  # services.greetd = {
  #   enable = true;
  #   settings.default_session = {
  #     command = "Hyprland --config /home/matyas/.config/regreet/hyprland.conf";
  #   };
  # };
  # programs.regreet.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      /home/zrl/dev/nixos-configs/common/users
      /home/zrl/dev/nixos-configs/common/base.nix
      /home/zrl/dev/nixos-configs/common/desktop.nix

      #/home/zrl/dev/nixos-configs/common/sway.nix
      /home/zrl/dev/nixos-configs/sway-experiment-lugia
    ];

  # Enables CPU microcode updates
  hardware.cpu.amd.updateMicrocode = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lugia"; # Define your hostname.
  networking.networkmanager.enable = true; # Enables NetworkManager to get us on the interwebz.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  # For network discovery of printers
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Enable the X11 windowing system
  services.xserver.enable = true;
  services.xserver.dpi = 163;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.supportDDC = true; # For external brightness control

  services.xserver.deviceSection = ''
    Option "VariableRefresh" "true"
  '';

  # Gimme dat Wacom
  services.xserver.wacom.enable = true;
  environment.systemPackages = with pkgs; [
    wacomtablet
    powerdevil # need for brightness management in KDE
  ];

  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  boot.extraModprobeConfig = "options kvm_amd nested=1";

  # Use amdgpu drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true; # But we don't open the port in the firewall, so only VPN can see it

  # Tailscale networking / VPN.
  services.tailscale.enable = true;

  # NFS share of home directory
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /home/zrl   100.99.132.36(rw,fsid=0,no_subtree_check)
  '';

  # Open ports in the firewall.

  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  networking.firewall.allowedUDPPorts = [
    config.services.tailscale.port # Not necessarily needed for Tailscale, but it may help sometimes
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

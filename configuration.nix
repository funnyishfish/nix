{ lib, inputs, config, pkgs, ... }:
{
	imports = [
			./hardware-configuration.nix
			./programs.nix
	];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	nixpkgs.config = {
		allowUnfree = true;
	};

	nix.settings = {
		experimental-features = [
			"nix-command"
			"flakes"
		];
	};

	networking.hostName = "nixos";
	networking.networkmanager.enable = true;

	time.timeZone = "America/New_York";
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

	services.gnome.gnome-keyring.enable = true;

	services.xserver.enable = true;
	services.xserver.videoDrivers = [ "nvidia" ];
	services.xserver.xkb = {
			layout = "us";
			variant = "";
		};

	services.displayManager.sddm.enable = true;
	services.desktopManager.plasma6.enable = true;
	services.power-profiles-daemon.enable = true;
	services.thermald.enable = true;

	services.printing.enable = true;

	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	services.flatpak.enable = true;
	xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	xdg.portal.config.common.default = "gtk";

	services.pcscd.enable = true;

	users.users."funnyishfish" = {
		isNormalUser = true;
		description = "fishy";
		extraGroups = [ "networkmanager" "wheel" ];
	};

	system.stateVersion = "26.05"; # do not touch
}

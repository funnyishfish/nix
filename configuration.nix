{ lib, inputs, config, pkgs, ... }:
{
	home-manager.users.funnyishfish = {
		home.stateVersion = "26.05";
			imports = [
				./nixcraft.nix
			];
		};
	home-manager.extraSpecialArgs = { inherit inputs; };
	imports = [
			./hardware-configuration.nix
			./programs.nix
	];

	musnix = {
		enable = true;
	};

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	nixpkgs.config = {
		allowUnfree = true;
	};

	nix.settings = {
		substituters = [ "https://deadlock-mod-manager.cachix.org" ];
		trusted-public-keys = [
			"deadlock-mod-manager.cachix.org-1:wUjtzL6yN2i9zTq1YrXHBr0mx3LP7tBGsosk3N+/A/M="
		];
		experimental-features = [
			"nix-command"
			"flakes"
		];
	};

	networking.hostName = "nixos";
	networking.networkmanager.enable = true;
	networking.firewall.checkReversePath = false;

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
		extraConfig.pipewire."92-low-latency" = {
			"context.properties" = {
				"default.clock.rate" = 48000;
				"default.clock.quantum" = 256;
				"default.clock.min-quantum" = 128;
				"default.clock.max-quantum" = 512;
			};
		};

		wireplumber.extraConfig = {
			"10-bluez" = {
				"monitor.bluez.properties" = {
					"bluez5.enable-sbc-xq" = true;
					"bluez5.enable-msbc" = true;
					"bluez5.enable-hw-volume" = true;
					"bluez5.codecs" = [ "sbc_xq" "sbc" ];
				};
			};
			"11-bluetooth-policy" = {
				"wireplumber.settings" = {
					"bluetooth.autoswitch-to-headset-profile" = false;
				};
			};
		};
	};

	services.flatpak.enable = true;
	xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	xdg.portal.config.common.default = "gtk";

	services.pcscd.enable = true;

	users.users."funnyishfish" = {
		isNormalUser = true;
		description = "fishy";
		extraGroups = [ "networkmanager" "wheel" "audio" ];
	};

	system.stateVersion = "26.05"; # do not touch
}

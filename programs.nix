{ inputs, config, pkgs, ... }:
{
	imports = [
		inputs.nixcord.nixosModules.nixcord
	];

	users.users."funnyishfish".packages = with pkgs; [
		kdePackages.kate
		kitty
		easyeffects
		rnnoise
		rnnoise-plugin
		prismlauncher
		yt-dlp
		fastfetch
		mpv
	];

	environment.systemPackages =
		let
			fp = pkgs.fishPlugins;
		in
		with pkgs; [
			fish
			steam-run
			protonup-qt
			gparted-full
			git
			fp.tide
			fp.done
			btop
			git-credential-manager
			gnupg
			pinentry-curses
			adwaita-icon-theme
			kdePackages.ksshaskpass
	];

	programs.obs-studio = {
		enable = true;
		package = pkgs.obs-studio.override {
			cudaSupport = true;
		};
		plugins = with pkgs.obs-studio-plugins; [
			obs-pipewire-audio-capture
			obs-aitum-multistream
		];
	};

	programs.nixcord = {
		enable = true;
		user = "funnyishfish";
		discord.equicord.enable = true;
		discord.krisp.enable = true;
		userPlugins.customStreamPreview = "github:MrTopQ/customStream-Vencord/cb2b6ac63e165de8210b4dca99bea0852f266d1c";
		extraConfig.plugins.customStreamPreview.enable = true;
	};

	programs.bash = {
		interactiveShellInit = ''
			if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
			then
				shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
				exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
			fi
		'';
	};

	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			set fish_greeting # Disable greeting
		'';
	};

	programs.steam = {
		enable = true;
		package = pkgs.steam.override {
			extraEnv = {
				LD_AUDIT = "${
					inputs.sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam
				}/SLSsteam.so";
			};
		};
	};

	programs.steam.extraCompatPackages = with pkgs; [
		proton-ge-bin
	];

	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
	};

	programs.git.enable = true;
	programs.gamemode.enable = true;
	programs.firefox.enable = true;
}

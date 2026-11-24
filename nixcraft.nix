{ config, pkgs, inputs, ... }: {
	imports = [
		inputs.nixcraft.homeModules.default
	];

	nixcraft = {
		enable = true;

		client = {
			shared = {
				enableExternalAssets = true;
				account = {
					uuid = "477c2271-d9eb-4b86-af87-42bee0647309";
				};
			};

			instances.ranked = {
				version = "1.16.1";
				desktopEntry.enable = true;

				mrpack = {
					enable = true;
					file = pkgs.runCommandLocal "ranked-mrpack" {} ''
						cp ${./extra/ranked.mrpack} $out
					'';
				};

				saves."Practice" = pkgs.fetchzip {
					url = "https://github.com/Dibedy/The-MCSR-Practice-Map/releases/download/latest/MCSR.Practice.v2.0.0.zip";
					stripRoot = false;
					hash = "sha256-zyCmVAypjspbbvaraaYQtckmpACn82TjZakXJf/JOYM=";
				};

				java = {
					package = pkgs.jdk17;
					minMemory = 3500;
					maxMemory = 3500;
					extraArguments = [
						"-XX:+UseZGC"
						"-XX:+AlwaysPreTouch"
						"-Dgraal.TuneInlinerExploration=1"
						"-XX:NmethodSweepActivity=1"
					];
				};

				waywall = {
					enable = true;
					configDir = ./extra/waywall;
				};

				binEntry = {
					enable = true;
					name = "mcsr-ranked";
				};
			};
		};
	};
}

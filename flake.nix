{
  description = "oh im flaking it";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixcord.url = "github:4evy/nixcord";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-alien.url = "github:thiagokokada/nix-alien";
    sls-steam = {
      url = "github:AceSLS/SLSsteam";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
      self,
      nixpkgs,
      nixcord,
      nixos-hardware,
      nix-alien,
      sls-steam,
      ...
    }@inputs : let
        system = "x86_64-linux";
        lib = nixpkgs.lib;
        pkgs-nix-alien = nix-alien.packages.${system};

        pkgs = (import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        });
    in {
        nixosConfigurations.fish = lib.nixosSystem {
            inherit system;
            modules = [
                ./configuration.nix
            ];
            specialArgs = {
                inherit inputs;
                inherit pkgs-nix-alien;
            };
        };
    };
}

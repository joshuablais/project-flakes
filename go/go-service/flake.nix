{
  description = "Go App Template Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      devenv,
      ...
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      nixosModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          options.services."#APP_NAME" = {
            enable = lib.mkEnableOption "#APP_NAME";
            port = lib.mkOption {
              type = lib.types.port;
              default = 8080;
            };
          };

          config = lib.mkIf config.services."#APP_NAME".enable {
            systemd.services."#APP_NAME" = {
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                ExecStart = "${self.packages.${pkgs.system}.default}/bin/#APP_NAME";
                Restart = "always";
                DynamicUser = true; # systemd creates/destroys user automatically
                EnvironmentFile = "/run/secrets/#APP_NAME";
              };
              environment = {
                PORT = toString config.services."#APP_NAME".port;
              };
            };
          };
        };

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [ ./devenv.nix ];
          };
        }
      );

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.buildGoModule {
            pname = "#APP_NAME";
            version = "0.1.0";
            src = ./.;
            vendorHash = "";
            subPackages = [ "cmd/#APP_NAME" ];
          };
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/#APP_NAME";
        };
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}

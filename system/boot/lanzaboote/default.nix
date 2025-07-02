{
  secrets,
  pkgs,
  lib,
  config,
  options,
  inputs,
  ...
}: let
    # preevaluate lanzaboote so we can pull boot.loader.external.installHook
    # this is very possibly the worst way to do it
    evalaboote = lib.evalModules {
        modules = [
            inputs.lanzaboote.nixosModules.lanzaboote
            {
                options = {
                    inherit (options) services systemd;
                    boot = { inherit (options.boot) bootspec loader kernelPackages; };
                };

                config = {
                    _module.args.pkgs.stdenv.hostPlatform.system = config._module.args.pkgs.stdenv.hostPlatform.system;
                    boot = {
                        inherit (config.boot) kernelPackages;

                        lanzaboote = builtins.removeAttrs
                            config.boot.lanzaboote
                            [ "package" ];
                    };
                };
            }
        ];

        specialArgs = {
        inherit pkgs;
        };
    };

in {
    # sbctl is used for the initial setup of secureboot
    environment.systemPackages = with pkgs; [
        sbctl
    ];

    boot = {
    
        loader = {
            external = {
                enable = true;
                installHook = lib.mkForce
                    (pkgs.concatScript "overlaidInstallHook" [
                        secrets.boot.secretsHook
                        evalaboote.config.boot.loader.external.installHook
                    ]);
            };
        };

        lanzaboote = {
            enable = true;
            publicKeyFile = secrets.boot.publicKeyFile;
            privateKeyFile = secrets.boot.privateKeyFile;
        };
    };
}

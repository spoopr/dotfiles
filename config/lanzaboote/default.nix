{
  pkgs,
  lib,
  config,
  options,
  dots,
  ...
} @ moduleArgs: let
    inherit (dots.args) secrets;
    inherit (dots) inputs;

    lzbtHook = ( # preevaulate lanzaboote separately so i can pull `installHook`
            # i kinda hate the module system sometimes
            inputs.lanzaboote.nixosModules.lanzaboote
                |> builtins.functionArgs
                |> builtins.attrNames
                |> (x: lib.getAttrs
                    x
                    moduleArgs
                )
                |> inputs.lanzaboote.nixosModules.lanzaboote
                |> (x: lib.evalModules {
                    modules = [
                        {
                            options = {
                                inherit (options)
                                    assertions
                                    environment
                                    services
                                    systemd;

                                boot = {
                                    inherit (options.boot)
                                        bootspec
                                        loader
                                        kernelPackages;
                                };
                            };

                            config = {
                                _module.args.pkgs.stdenv.hostPlatform.system = config._module.args.pkgs.stdenv.hostPlatform.system;

                                boot = {
                                    inherit (config.boot) kernelPackages;

                                    lanzaboote = builtins.removeAttrs
                                        config.boot.lanzaboote
                                        [ "package" "installCommand" ];
                                };
                            };
                        }
                        x
                    ];

                    specialArgs = {
                        inherit pkgs;
                    };
                })
                |> (x: x.config.boot.loader.external.installHook)
        );
in {
    dotfiles.args.secrets.enable = true;

    imports = with inputs; [
        lanzaboote.nixosModules.lanzaboote
    ];

    boot = {
        lanzaboote = {
            enable = true;

            publicKeyFile = secrets.boot.publicKeyFile;
            privateKeyFile = secrets.boot.privateKeyFile;
        };

        # wrap lanzaboote's install hook and force its use
        loader.external.installHook = lib.mkForce
            (secrets.boot.wrapLzbtHook lzbtHook);

    };
}

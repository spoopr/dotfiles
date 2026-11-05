{
    dots,
    lib,
    cfg,
    ...
}: let
    inherit (dots) inputs;
in {
    dotfiles.self.options = {
        domains = lib.mkOption {
            default = [];
            type = lib.types.listOf lib.types.path;
        };
    };

    imports = with inputs; [
        nixvirt.nixosModules.default
    ];

    virtualisation.libvirt = {
        enable = true;

        connections."qemu:///system".domains = cfg.options.domains
            |> map (x:
                {
                    definition = x;
                    active = true;
                }
            );
    };
}

{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

        nix-index-database.url = "github:nix-community/nix-index-database";

        nixos-hardware.url = "github:nixos/nixos-hardware";

        secrets.url = "/nix/persist/repos/secrets";
        colors.url = "github:spoopr/lavndr";

        lanzaboote.url =  "github:nix-community/lanzaboote/v1.1.0";
        impermanence.url = "github:nix-community/impermanence";

        import-tree.url = "github:vic/import-tree";
        flake-parts.url = "github:hercules-ci/flake-parts";
    };

    outputs = {
        flake-parts,
        ...
    } @ inputs: flake-parts.lib.mkFlake
        { inherit inputs; }
        {
            systems = [
                "x86_64-linux"
            ];

            imports = [
                ./hosts
                ./config
                ./tools
            ];
        };

}

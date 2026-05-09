{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

        secrets.url = "/nix/persist/repos/secrets";
        colors.url = "github:spoopr/lavndr";

        impermanence.url = "github:nix-community/impermanence";

        inputs.import-tree.url = "github:vic/import-tree";
        inputs.flake-parts.url = "github:hercules-ci/flake-parts";
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
                ./system
                ./config
                ./tools
            ];
        };

}

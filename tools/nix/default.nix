{
    inputs,
    ...
}: let
    inherit (inputs) homebrew;
in {
    imports = [
        (homebrew.modules.mkCustomOutput [ "lib" ])
    ];
}

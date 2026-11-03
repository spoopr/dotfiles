{
    dots,
    ...
}: let
    inherit (dots.inputs) disko;
in {
    dotfiles.self.forceEnable = true;

    imports = [
       disko.nixosModules.disko
    ];
}

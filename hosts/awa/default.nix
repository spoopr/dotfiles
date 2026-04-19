{
  inputs,
  ...
}: let
    inherit (inputs) nixos-hardware;
in {
    #[see](https://guides.frame.work/Guide/NixOS+on+the+Framework+Laptop+13/400)
    imports = [
        nixos-hardware.nixosModules.framework-13-7040-amd
    ];

    # add tuning to new "Framework Speakers" device
    # [see](https://github.com/NixOS/nixos-hardware/blob/master/framework/13-inch/common/audio.nix)
    hardware.framework.laptop13.audioEnhancement.enable = true;

    system.stateVersion = "24.05";
}

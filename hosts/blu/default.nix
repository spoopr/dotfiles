{
    pkgs,
    lib,
    config,
    ...
}: {
    imports = [
        ./hardware-configuration.nix
        ./disko-configuration.nix
    ];

	networking.hostId = "20948736";

	boot = {
		loader = {
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
		};
	};

	system.stateVersion = "26.11";
}

{
    ...
}: {
    imports = [
        ./hardware-configuration.nix
        ./disko-configuration.nix
    ];

	networking.hostId = "20948736";

	boot = {
		loader = {
			efi.canTouchEfiVariables = true;
		};
	};

	system.stateVersion = "26.11";
}

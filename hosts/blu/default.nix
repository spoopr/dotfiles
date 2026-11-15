{
    ...
}: {
    imports = [
        ./hardware-configuration.nix
        ./disko-configuration.nix
    ];

	dotfiles = {
		system.network.wpa_supplicant.options = {
			wireless = {
				enable = true;
				detectInterfaces = true;
			};
			wired = {
				enable = true;
				detectInterfaces = true;
			};
		};

		user.nvim.enable = true;
	};

	networking.hostId = "20948736";

	boot = {
		loader = {
			efi.canTouchEfiVariables = true;
		};
	};

	system.stateVersion = "26.11";
}

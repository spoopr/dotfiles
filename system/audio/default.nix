{
  ...
}: {
	services.pipewire = {
		enable = true;
		alsa = {
			enable = true;
			support32Bit = true;
		};
		pulse.enable = true;
		
		wireplumber = {
			extraConfig = {
				"default-silent" = {
					"wireplumber.settings" = {
						"device.routes.default-sink-volume" = 0.0;
					};
				};
			};
		};
	};

	security.rtkit.enable = true;
}

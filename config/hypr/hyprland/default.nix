{
  pkgs,
  colors,
  ...
}: let

	wrapperlandConfig = builtins.toFile "wrapperlandConfig" (''
		$primaryColor = rgb(${builtins.substring 1 (-1) colors.lavendar.hex})
		$secondaryColor = rgb(${builtins.substring 1 (-1) colors.black.hex})
	'' + (builtins.readFile ./hyprland.conf)
	);

	wrapperland = (pkgs.symlinkJoin {
		name = "wrappedHyprland";
		paths = [ pkgs.hyprland ];
		buildInputs = [ pkgs.makeWrapper ];
		postBuild = ''
		wrapProgram $out/bin/Hyprland --add-flags "-c ${wrapperlandConfig}"
		'';
	});

in {

	environment.systemPackages = [
		wrapperland	
	];

	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [ 
			xdg-desktop-portal-gtk
		];
		configPackages = [ wrapperland ];

		wlr.enable = false;
	};

	security = {
		polkit.enable = true;
	};

	programs = {
		dconf.enable = true;
		xwayland.enable = true;
	};

	services.graphical-desktop.enable = true;
}

{
  pkgs,
  ...
}: let
	config = pkgs.writeText "hyprpaper.conf" ''
		splash = false
		ipc = false

		preload = ${./osaka.png}
		wallpaper = , ${./osaka.png}
	''; 

in {
	environment.systemPackages = [
		(pkgs.symlinkJoin {
			name = "wrappedHyprpaper";
			paths = [ pkgs.hyprpaper ];
			buildInputs = [ pkgs.makeWrapper ];
			postBuild = ''
				wrapProgram $out/bin/hyprpaper --add-flags "-c ${config}"
			'';
		})
	];
}

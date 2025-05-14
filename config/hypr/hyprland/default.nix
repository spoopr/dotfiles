{
  pkgs,
  ...
}: {
	environment.systemPackages = [
		(pkgs.symlinkJoin {
			name = "wrappedHyprland";
			paths = [ pkgs.hyprland ];
			buildInputs = [ pkgs.makeWrapper ];
			postBuild = ''
				wrapProgram $out/bin/Hyprland --add-flags "-c ${./hyprland.conf}"
			'';
		})
	];
}

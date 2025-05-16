{
  pkgs,
  ...
}: {
	environment.systemPackages =  [
		(pkgs.symlinkJoin {
			name = "wrapperlock";
			paths = [ pkgs.hyprlock ];
			buildInputs = [ pkgs.makeWrapper ];
			postBuild = ''
			wrapProgram $out/bin/hyprlock --add-flags "-c ${./hyprlock.conf}"
			'';
		})
	];

	security.pam.services.hyprlock = {};
}

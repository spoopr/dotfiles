{
  pkgs,
  ...
}: {
	environment.systemPackages = [
		(pkgs.symlinkJoin {
			name = "wrappedFoot";
			paths = [ pkgs.foot ];
			buildInputs = [ pkgs.makeWrapper ];
			postBuild = ''
				wrapProgram $out/bin/foot --add-flags "-c ${./foot.ini}"
			'';
		})
	];
}

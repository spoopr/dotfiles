{
  pkgs,
  ...
}: {
	environment.systemPackages = with pkgs; [
		glow
	];
}

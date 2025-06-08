{
  ...
}: {
	imports = [
		./boot
		./nix
		./security
		./network
		./firmware
		./users
		./fonts
		./peripherals
		./audio
	];

	time.timeZone = "America/Chicago";
	system.stateVersion = "24.05";
}

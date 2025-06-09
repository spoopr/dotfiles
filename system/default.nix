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
}

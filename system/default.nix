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
  ];

  time.timeZone = "America/Chicago";
  system.stateVersion = "24.05";
}

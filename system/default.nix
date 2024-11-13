{
  ...
}: {
  imports = [
    ./boot
    ./nix
    ./security
    ./network
    ./services
    ./users
  ];

  time.timeZone = "America/Chicago";
  system.stateVersion = "24.05";
}

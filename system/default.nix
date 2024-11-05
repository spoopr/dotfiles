{
  ...
}: {
  imports = [
    ./boot
    ./nix
    ./security
    ./network
    ./services
  ];

  time.timeZone = "America/Chicago";
  system.stateVersion = "24.05";
}

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
    ./secrets
  ];

  time.timeZone = "America/Chicago";
  system.stateVersion = "24.05";
}

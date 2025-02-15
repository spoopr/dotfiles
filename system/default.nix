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
    ./secrets
    ./fonts
  ];

  time.timeZone = "America/Chicago";
  system.stateVersion = "24.05";
}

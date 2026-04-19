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
        ./display
        ./comma
    ];

    time.timeZone = "America/Chicago";
}

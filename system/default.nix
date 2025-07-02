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
    ];

    time.timeZone = "America/Chicago";
}

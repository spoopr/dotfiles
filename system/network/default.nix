{
  ...
}: {
  networking = {
    firewall = {
      enable = true;
      allowPing = false;
      logReversePathDrops = true;
    };

  };
}

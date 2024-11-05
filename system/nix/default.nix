{
  pkgs,
  ...
}: {
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      sandbox = true;
      allowed-users = [ "@wheel" ];
      trusted-users = [ "@wheel" ];
    };

  };

  # environment.defaultPackages = lib.mkForce [];
}

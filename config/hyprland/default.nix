{
  inputs,
  pkgs,
  host,
  ...
}: {
  nix.settings = {
    substituters = [ "https://hyprland.chacix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  programs.hyprland = {
    enable = true;

    xwayland.enable = true;
  };

}

{
  pkgs,
  packages ? [],
}: let
  checkForConfig = directory: name: 
    if builtins.pathExists (directory + ("/" + name))
      then (directory + ("/" + name))
      else {} ;
in {
  imports = map (checkForConfig ../modules/pkgs) packages;
  environment.systemPackages = map (x: pkgs.${x}) packages;
}  

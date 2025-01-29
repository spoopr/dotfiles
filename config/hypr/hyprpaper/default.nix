{
  pkgs,
  ...
}: let
  config = pkgs.writeText "hyprpaper.conf" ''
    splash = false
    ipc = false

    preload = ${./behold.jpg}
    wallpaper = , ${./behold.jpg}
  ''; 
in {
  environment.systemPackages = with pkgs; [
    (pkgs.symlinkJoin {
      name = "wrappedHyprpaper";
      paths = [
        pkgs.hyprpaper
      ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/hyprpaper --add-flags "-c ${config}"
      '';
     })
  ];
}

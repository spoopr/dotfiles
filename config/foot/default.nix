{
  pkgs,
  colors,
  ...
}: let
    configuration = builtins.toFile "wroop" (
        ''
            [colors]
            foreground=${colors.white.hexNoHash}
            background=${colors.black.hexNoHash}

            regular0=${colors.gray.hexNoHash}
            regular1=${colors.red.hexNoHash}
            regular2=${colors.green.hexNoHash}
            regular3=${colors.orange.hexNoHash}
            regular4=${colors.blue.hexNoHash}
            regular5=${colors.purple.hexNoHash}
            regular6=${colors.teal.hexNoHash}
            regular7=${colors.white.hexNoHash}

            bright0=${colors.light_gray.hexNoHash}
            bright1=${colors.red.hexNoHash}
            bright2=${colors.teal.hexNoHash}
            bright3=${colors.yellow.hexNoHash}
            bright4=${colors.light_blue.hexNoHash}
            bright5=${colors.lavendar.hexNoHash}
            bright6=${colors.green.hexNoHash}
            bright7=${colors.white.hexNoHash}
        '' + (builtins.readFile ./foot.ini)
    );


in {

    environment.systemPackages = [
        (pkgs.symlinkJoin {
            name = "wrappedFoot";
            paths = [ pkgs.foot ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
                wrapProgram $out/bin/foot --add-flags "-c ${configuration}"
            '';
        })
    ];
}

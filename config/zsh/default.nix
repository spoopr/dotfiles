{
  pkgs,
  ...
}: let

  zshrc = pkgs.writeShellScriptBin ".zshrc" ''
    source ${./config.zsh}
	source ${./autocomplete.zsh}
	source ${./aliases.zsh}
  '';

in {

  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "wrappedZsh";
      paths = [ pkgs.zsh ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
	wrapProgram $out/bin/zsh --set ZDOTDIR "${zshrc}/bin"
      '';
    })
  ];

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
}

{
  pkgs,
  ...
}: let 
  config = {
    customRC = ''
      :luafile ${./init.lua}
    '';
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
      nvim-treesitter.withAllGrammars
    ];
  };
in {
  environment.systemPackages = [
    (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped config)
  ];

  environment.variables.EDITOR = "nvim";

  programs.nano.enable = false;
}

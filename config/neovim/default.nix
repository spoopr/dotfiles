{
  pkgs,
  ...
}: let 
  config = pkgs.neovimUtils.makeNeovimConfig {
    customRC = ''
      :luafile ${./init.lua}
    '';
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      leap-nvim
    ];
  };
in {
  environment.systemPackages = [
    (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped config)
  ];

  environment.variables.EDITOR = "nvim";

  programs.nano.enable = false;
}

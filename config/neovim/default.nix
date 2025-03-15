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

	  # autocomplete
	  nvim-cmp
	  nvim-lspconfig
	  cmp-buffer
	  cmp-nvim-lsp
    ];
  };
in {
  environment.systemPackages = with pkgs; [
    # language servers
	jdt-language-server
	lua-language-server
	nixd
	typescript-language-server
  ] ++ [
    (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped config)
  ];

  environment.variables.EDITOR = "nvim";

  programs.nano.enable = false;
}

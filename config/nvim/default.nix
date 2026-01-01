{
  pkgs,
  lib,
  ...
}: let 
    config = pkgs.neovimUtils.makeNeovimConfig {
	customRC = [
	    ./luaConfig/vim.lua
	    ./luaConfig/lsp.lua
	    ./luaConfig/cmp.lua
	    ./luaConfig/treesitter.lua
	    ./luaConfig/leap.lua
	]
	    |> builtins.map (file: ":luafile ${file}")
	    |> lib.strings.concatStringsSep "\n";

        plugins = with pkgs.vimPlugins; [
            nvim-treesitter.withAllGrammars
            leap-nvim
            bullets-vim

            # autocomplete
            nvim-cmp
            cmp-buffer
            cmp-nvim-lsp
            cmp-treesitter
        ];
    };

in {
    environment = {
        systemPackages = with pkgs; [
            # language servers
            jdt-language-server
            lua-language-server
            nixd
            typescript-language-server

            # copy / paste
            wl-clipboard
        ] ++ [
            (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped config)
        ];

        variables = {
            EDITOR = "nvim";
        };
    };

    programs.nano.enable = false;
}

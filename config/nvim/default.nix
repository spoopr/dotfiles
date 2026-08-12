{
  pkgs,
  lib,
  ...
}: let 
    config = {
	luaRcContent = [
	    ./luaConfig/vim.lua
	    ./luaConfig/lsp.lua
	    ./luaConfig/cmp.lua
	    ./luaConfig/treesitter.lua
	    ./luaConfig/leap.lua
        ./luaConfig/indent-blankline.lua
        ./luaConfig/autoclose.lua
        ./luaConfig/gitsigns.lua
        ./luaConfig/bullets.lua
	]
	    |> builtins.map (file: builtins.readFile file)
	    |> lib.strings.concatStringsSep "\n";

        plugins = with pkgs.vimPlugins; [
            nvim-treesitter.withAllGrammars
            leap-nvim
            bullets-vim
            indent-blankline-nvim
            autoclose-nvim
            gitsigns-nvim
            fidget-nvim

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
            clang-tools # clangd's in here

            # copy / paste
            wl-clipboard
        ] ++
        config.plugins
        ++ [
            (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped config)
        ];

        variables = {
            EDITOR = "nvim";
        };
    };

    programs.nano.enable = false;
}

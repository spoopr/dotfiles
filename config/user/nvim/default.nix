{
  pkgs,
  lib,
  dots,
  ...
}: let 
	inherit (dots.inputs) import-tree;

    config = {
	luaRcContent = import-tree
		|> (x: x.initFilter (lib.hasSuffix ".lua"))
		|> (x: x.leaves ./lua)
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
            virt-column-nvim

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

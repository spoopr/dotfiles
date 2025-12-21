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
            cmp-buffer
            cmp-nvim-lsp
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

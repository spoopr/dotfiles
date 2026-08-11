{
    dots,
    ...
}: let
    inherit (dots.inputs) colors;
in {
    dotfiles.meta.args.colors = colors.colors;
}

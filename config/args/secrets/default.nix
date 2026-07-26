{
    dots,
    ...
}: let
    inherit (dots.inputs) secrets;
in {
    dotfiles.meta.args.secrets = secrets.hostSecrets.${dots.args.hostName};
}

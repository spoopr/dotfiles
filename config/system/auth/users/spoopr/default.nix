{
    dots,
    ...
}: let
    inherit (dots.args) secrets;
in {
    dotfiles.args.secrets.enable = true;

    users.users.spoopr = {
        isNormalUser = true;
        extraGroups = [
            "wheel"
            "netdev"
        ];
        hashedPasswordFile = secrets.passwords.spoopr;
    };
}

{
    dots,
    ...
}: let
    inherit (dots.args) secrets;
in {
    dotfiles = {
        self.forceEnable = true;

        args.secrets.enable = true;
    };

    users = {
        users.root = {
            hashedPasswordFile = secrets.passwords.root;
        };

        # probably a good thing to do with this impermanence setup
        mutableUsers = false;
    };
}

{
    dots,
    ...
}: let
    inherit (dots.args) secrets;
in {
    dotfiles.args.secrets.enable = true;

    users ={
        users = {
            root = {
                hashedPasswordFile = secrets.passwords.root;
            };

            spoopr = {
                isNormalUser = true;
                extraGroups = [
                    "wheel"
                    "networkmanager"
                ];
                hashedPasswordFile = secrets.passwords.spoopr;
            };
        };

        # probably a good thing to do with this impermanence setup
        mutableUsers = false;
    };
}

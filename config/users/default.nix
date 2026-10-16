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
        extraUsers = { 
		root = {
		    #hashedPasswordFile = secrets.passwords.root;
		password  = "toor";

		};
	
	};

        # probably a good thing to do with this impermanence setup
        mutableUsers = false;
    };
}

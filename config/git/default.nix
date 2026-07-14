{
  ...
}: {
    programs.git = {
        enable = true;
        config = {
            user = {
                email = "spoopr@nootr.dev";
                name = "spoopr";
                signingkey = "${./pen.pub}";
            };

            init.defaultBranch = "main";
            gpg.format = "ssh";
            commit.gpgSign = true;
            tag.gpgSign = true;
            clean.requireForce = false;
            pull.rebase = false;
        };
    };
}

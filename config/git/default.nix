{
  ...
}: {
    programs = {
        git = {
            enable = true;
            config = {
                user = {
                    email = "spoopr@nootr.dev";
                    name = "spoopr";
                    signingkey = "${./keys/pen.pub}";
                };

                init.defaultBranch = "main"; 
                gpg.format = "ssh";
                commit.gpgSign = true;
                tag.gpgSign = true;
                clean.requireForce = false;
                pull.rebase = false;
            };
        };

        ssh.knownHosts = {
            "github/ed25519" = {
                hostNames = [ "github.com" ];
                publicKey = "${builtins.readFile ./keys/github.ed25519.pub}";
            };
            "github/sha2" = {
                hostNames = [ "github.com" ];
                publicKey = "${builtins.readFile ./keys/github.sha2.pub}";
            };
            "github/rsa" = {
                hostNames = [ "github.com" ];
                publicKey =  "${builtins.readFile ./keys/github.rsa.pub}";
            };
        };
    };
}

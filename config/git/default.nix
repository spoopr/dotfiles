{
  ...
}: {
    programs.ssh.knownHosts = {
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
}

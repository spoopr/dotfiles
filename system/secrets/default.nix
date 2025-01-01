{
  pkgs,
  lib,
  ...
}: {

  age = {
    ageBin = "PATH=$PATH:${lib.makeBinPath [pkgs.age-plugin-tpm]} ${pkgs.age}/bin/age";
    identityPaths = [ "/nix/persist/secrets/awa" ];

    secrets = {
        rootPassword.file = /nix/persist/secrets/buildSecrets/passwords/root.age;
	spooprPassword.file = /nix/persist/secrets/buildSecrets/passwords/spoopr.age;
    };
  };

}


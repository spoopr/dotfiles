{
  pkgs,
  lib,
  inputs,
  host,
  ...
}: let
  inherit (inputs) agenix;
in {
  environment.systemPackages = with pkgs; [
    age-plugin-fido2-hmac
    age-plugin-tpm
    agenix.packages.${host.system}.default
  ];

  age = {
    ageBin = "PATH=$PATH:${lib.makeBinPath [pkgs.age-plugin-tpm]} ${pkgs.age}/bin/age";
    identityPaths = [ "/nix/persist/secrets/identities/awa" ];
  };

}


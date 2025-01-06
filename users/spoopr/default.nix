{
  pkgs,
  config,
  ...		
}: {
  imports = [
    (import ../buildDependencies.nix {
      inherit pkgs;
      packages = [
        "git"
	"gh"
        "sbctl"
	"age-plugin-fido2-hmac"
	"age-plugin-tpm"
      ];
    })
  ]; 

  users.users.spoopr = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel" 
      "networkmanager"
    ];
    hashedPasswordFile = config.age.secrets.spooprPassword.path;
  };
}
  

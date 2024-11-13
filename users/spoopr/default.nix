{
  pkgs,
  ...		
}: {
  imports = [
    (import ../buildDependencies.nix {
      inherit pkgs;
      packages = [
        "git"
	"gh"
      ];
    })
  ]; 

  users.users.spoopr = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = "/nix/persist/secrets/spoopr";
  };
}
  

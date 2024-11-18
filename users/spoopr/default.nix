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
        "sbctl"
      ];
    })
  ]; 

  users.users.spoopr = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = "/nix/persist/secrets/spoopr";
  };
}
  

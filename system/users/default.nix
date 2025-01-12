{
  config,
  ...
}: {
  users.users = {
    root = {
      hashedPasswordFile = config.age.secrets.rootPassword.path;
    };

    spoopr = {
      isNormalUser = true;
      extraGroups = [
	"wheel"
	"networkmanager"
      ];
      hashedPasswordFile = config.age.secrets.spooprPassword.path;
    };
  };
}

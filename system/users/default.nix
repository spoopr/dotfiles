{
  secrets,
  ...
}: {
	users.users = {
		root = {
			hashedPasswordFile = secrets.passwords.root;
		};

		spoopr = {
			isNormalUser = true;
			extraGroups = [
			"wheel"
			"networkmanager"
			];
			hashedPasswordFile = secrets.passwords.spoopr;
		};
	};
}

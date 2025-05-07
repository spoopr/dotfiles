{
  ...
}: {
	programs.ssh = {
		enableAskPassword = true;
	};

	services = {
		openssh.settings = {
			passwordAuthentication = false;
			allowSFTP = false;
			challengeResponseAuthentication = false;
			extraConfig = ''
				AllowTcpForwarding yes
				X11Forwarding no
				AllowAgentForwarding no
				AllowStreamLocalForwarding no
				AuthenticationMethods publickey
			'';
		};

		sshd.enable = false;
	};
}	

{
  pkgs,
  ...
}: {
  security = {
    protectKernelImage = true;
    lockKernelModules = true;
    forcePageTableIsolation = true;
  
    auditd.enable = true;
    audit = {
      enable = true;
      rules = [ "-a exit,always -F arch=x86_64 -S execve" ];
    };
  };
	
}

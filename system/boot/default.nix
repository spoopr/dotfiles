{
  pkgs,
  secrets,
  inputs,
  config,
  options,
  ...
}: let
	inherit (pkgs) lib;

	# preevaluate lanzaboote so we can pull boot.loader.external.installHook
	evalaboote = lib.evalModules {
		modules = [
			inputs.lanzaboote.nixosModules.lanzaboote
			{
				options = {
					inherit (options) services systemd;
					boot = { inherit (options.boot) bootspec loader kernelPackages; };
				};

				config = {
					_module.args.pkgs.stdenv.hostPlatform.system = config._module.args.pkgs.stdenv.hostPlatform.system;
					boot = {
						inherit (config.boot) kernelPackages;

						lanzaboote = builtins.removeAttrs
							config.boot.lanzaboote
							[ "package" ];
					};
				};
			}
		];

		specialArgs = {
			inherit pkgs;
		};
	};


in {  

  environment.systemPackages = with pkgs; [
	tpm2-tss
	sbctl
  ];

  boot = {
	loader = {
	  timeout = 0;
	  efi.canTouchEfiVariables = true;
	
		external = {
			enable = true;
			installHook = lib.mkForce
				( pkgs.concatScript "overlaidInstallHook" [
					secrets.boot.overlaidInstallHook
					evalaboote.config.boot.loader.external.installHook
				]);
		};
	};

	lanzaboote = {
		enable = true;
		  publicKeyFile = secrets.boot.publicKeyFile;
		  privateKeyFile = secrets.boot.privateKeyFile;
	};

	initrd = { 
	  systemd.enable = true;

	  luks.devices = {
		root = {
		  device = "/dev/nvme0n1p2";
		  preLVM = true;
		};
	  };
	};

	tmp = {
	  cleanOnBoot = true;
	  useTmpfs = true;
	};

  };

  environment = {
	persistence."/nix/persist" = {
	  directories = [
		"/etc/nixos"
		"/srv"
		"/var/lib"
		"/var/log"
	  ];
	};
  
	etc."machine-id".source = "/nix/persist/etc/machine-id";

  };

}

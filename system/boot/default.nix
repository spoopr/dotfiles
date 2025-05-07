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

	environment.systempackages = with pkgs; [
		tpm2-tss
		sbctl
	];

	boot = {
		loader = {
			timeout = 0;
			efi.cantouchefivariables = true;

			external = {
				enable = true;
				installhook = lib.mkforce
					(pkgs.concatscript "overlaidinstallhook" [
						secrets.boot.secretshook
						evalaboote.config.boot.loader.external.installhook
					]);
			};
		};

		lanzaboote = {
			enable = true;
			publickeyfile = secrets.boot.publickeyfile;
			privatekeyfile = secrets.boot.privatekeyfile;
		};

		initrd = {
			systemd.enable = true;

			luks.devices = {
				root = {
					device = "/dev/nvme0n1p2";
					prelvm = true;
				};
			};
		};

		tmp = {
			cleanonboot = true;
			usetmpfs = true;
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

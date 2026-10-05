{
  pkgs,
  ...
}: let
in {
    # boy do i love debugging this
    #
    # its been three times now

    # i straight up copy pasted this from
    # https://github.com/NixOS/nixpkgs/blob/7241bcbb4f099a66aafca120d37c65e8dda32717/nixos/modules/programs/ssh.nix
    # with just a little editing to replace the module config references
    #
    # i should probably learn systemctl services sometime
    systemd.user.services.ssh-agent = {
        description = "turbo-agent";
        wantedBy = [ "default.target" ];
        unitConfig.ConditionUser = "!@system";
        serviceConfig = {
            ExecStartPre = "${pkgs.coreutils}/bin/rm -f %t/ssh-agent";
            ExecStart = "${pkgs.openssh}/bin/ssh-agent -a %t/ssh-agent";
            StandardOutput = "null";
            Type = "forking";
            Restart = "on-failure";
            SuccessExitStatus = "0 2";
        };
        environment.SSH_ASKPASS = 
            "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
        environment.DISPLAY = ":0"; # required to make x11-ssh-askpass not shit 
            # its pants
    };

    environment.variables.SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent";
}   

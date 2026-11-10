{
    ...
}: {
    dotfiles.self.forceEnable = true;

    services.logind.settings.Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "suspend";
        HandleLidSwitchDocked = "suspend";
        KillUserProcesses = true;
    };
}

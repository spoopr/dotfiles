{
    ...
}: {
    dotfiles.self.forceEnable = true;

    services.logind.settings.Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchDocked = "suspend";
        KillUserProcesses = true;
    };
}

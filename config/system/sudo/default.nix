{
  ...
}: {
    dotfiles.self.forceEnable = true;

    security.sudo = {
        execWheelOnly = true;
        extraConfig = ''
            Defaults lecture=never

            Defaults timestamp_timeout=0
            Defaults: %wheel rootpw
            %wheel ALL=(ALL) ALL
        '';
    };
}

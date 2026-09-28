# using `disko-install`

## getting `hardware-configuration.nix`
its entirely possible to do this without having mounted any drives first,
apparently.

``` bash
nixos-generate-config --no-filesystems
```

add the generated `hardware-configuration.nix` into your config.

## configuration notes
it probably depends on what partition scheme and other hardware you're running,
but i was getting some issues with installing the bootloader; these config
lines fixed it:

```nix
{
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.enable = true;
}
```

## `disko-install`
compared to plain `disko`, `disko-install` requires that you manually specify
each `disko.devices.disk` item via commandline.

```bash
disko-install --flake <path>#<config> --disk <diskname> /dev/<whatever>
```

assuming the install is successful:
```bash
reboot
```

# done

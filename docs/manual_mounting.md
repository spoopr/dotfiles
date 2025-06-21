# manually mounting the filesystem
i don't do this often so i forget yknow

## decrypting
```bash
cryptsetup luksOpen $PARTITION $DECRYPTED
```

## lvm 
```bash
lvscan
vgchange -ay
```

## mounting
```bash
mkdir -p /mnt/{boot,nix}
mount -t tmpfs none /mnt
mount $BOOT /mnt/boot
mount $MAIN /mnt/nix
swapon $SWAP
```

# done

# enabling unattended LUKs decryption
assuming secureboot is enabled:
```bash
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7+8 /dev/${path to LUKs partition}
```

# done

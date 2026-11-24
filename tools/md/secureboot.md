# adding secureboot

## prep
### enter setup mode
for frameworks:
1. in bios settings, go to "Administer Secure Boot"
2. enable "Erase all Secure Boot Settings"
3. exit saving changes
### create keys
```bash
sudo sbctl create-keys -e ${path to keys directory} 
```

## enabling
### enroll keys
```bash
sudo sbctl import-keys --directory ${path to keys directory}
sudo sbctl enroll-keys
```
reboot to enact changes

# done

[^source]: [official lanzaboote docs](https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md)

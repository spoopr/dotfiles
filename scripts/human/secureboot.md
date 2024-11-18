# adding secureboot

## prep
### create keys
```bash
sudo sbctl create-keys -d ${path to keys database} 
```

## enabling
### enter setup mode
this varies from system to system, look it up
### enroll keys
```bash
sudo sbctl enroll-keys --microsoft -d ${database path}
```
reboot to enact changes

# done

[^source]: [official lanzaboote docs](https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md)

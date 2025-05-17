> :3

My personal NixOS configuration, designed however I was feeling on whatever day it was written. Good luck.


<br />


## Structure
In terms of the overall structure, I would describe my organization as "bottom-up." 
What that means is if a particular app or feature requires some other configuration, systemwide or not, it is installed within that same subfolder.
Even if the configuration already exists somewhere else, the redundancy is acceptable, encouraged even.

Additionally, every individual unit of configuration is placed in its own subfolder with a `default.nix` file. 

In practice, most of the time all this means is that imports are in the form:
```
./something
```
Rather than:
```
./something.nix
```
But I do this for an organization, and to be frank, visual consistency.
## 


### `config`
This is where all not-absolutely essential configuration is imported. Typically, these are higher level apps.

### `docs`
A collection of personal notes in `.md` format. I keep these to remember the different commands I don't use often.

### `hosts`
Each subfolder contains configuration specific to a particular machine, the name of which is the subfolder name.

### `system`
All of the mostly to absolutely essential configuration, like configuring boot, user, and security settings.


<br />

## System structure
This is what I imagine would be the largest hurdle for anyone trying to adopt this configuration. 

First of all, my configuration uses `impermanence`. While this isn't too restrictive in itself, it does require some
consideration when installing certain programs. Additionally, since `/` is not persistent, the disk
partition that I assume normally would be bound to it is bound to `/nix` instead.

Second, this configuration uses a custom [`agenix`](https://github.com/ryantm/agenix) based secrets flake.
The secrets themselves are split by host, and the secrets flake assumes that any given host has a TPM to encrypt
and decrypt secrets against. While I do plan to publish a template of said flake in the future, I have
higher priorities until then.

> [!CAUTION]
> As I understand it, since `/` is mounted as a `tmpfs`, and since `agenix` decrypts all host secrets to plaintext
> in `/run/agenix` at runtime, albeit access restricted, all host secrets are stored plaintext in ram. Thus, this
> configuration is probably particularly sensitive to ram exploits, like DMA attacks.  

Third, and really the least important, this configuration assumes that your system is secureboot compatible and that 
secureboot is enabled. This stretches a little beyond scope of NixOS dotfiles, but the disk partitions for any given 
machine are assumed to be LUKS encrypted, which I've bound to be unlocked automatically on boot by the TMP.
The TMP itself checks the contents of the boot partition and whether secureboot completed successfully before
releasing the LUKS partition key.


<br />


## Security / Privacy
This is more for myself, as a to-do and a to-done. If you think there's any possible vectors or attack types I'm missing,
please, let me know.
## 

- [x] Evil maid attacks
	- [x] Secureboot
	- [x] LUKS encrypted disks, locked against the TPM with PCRs 0, 2, 7, 8
- [ ] DMA attacks
	- Supposedly the firmware in `awa` will halt a boot if chassis intrusion is detected, but I don't know if it will shutdown
	on a detected chassis intrusion after boot.
	- If not, then I need to create a service to do so.
- [ ] Kernel modules
	- It'd probably be a good idea to blacklist certain modules
	- [ ] Enable additional entropy modules?
- [ ] General kernel and boot hardening
- [ ] Restrict access on important directories
- [ ] Zram / Zswap to reduce the chance of swapping important data
- [ ] Encrypted swap partition
- [ ] Isolate / restrict USB and other ports
- [ ] Harden / anonymize wireless connections
	- [x] `dhcpcd` is configured with the `anonymous` flag, which implements [RFC 7488](https://datatracker.ietf.org/doc/html/rfc7488)
- [ ] Implement an official ProtonVPN app
	- To allow for much easier / automatic rotation of VPN host servers

<br />


## Credits
I'd like to thank these few, from which I've derived parts of my knowledge or design.

<p align="center">
  <a href="https://github.com/sioodmy">sioodmy</a> - 
  <a href="https://github.com/vimjoyer">vimjoyer</a> -
  <a href="https://github.com/raexera">raexera</a> -
  <a href="https://github.com/xe">xe</a> -
  <a href="https://github.com/ryantm">ryantm</a> -
  <a href="https://github.com/qfpl">qfpl</a> - 
  <a href="https://github.com/cynicsketch">cynicsketch</a>
</p>

And to those I've forgotten, thank you aswell.

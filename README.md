> :3


## Structure
In terms of the overall structure, I would describe my organization as
"bottom-up." What that means is if a particular app or feature requires some
other configuration, systemwide or not, it is installed or requiredwithin that
same subfolder. Even if the configuration already exists somewhere else, the
redundancy is acceptable, encouraged even.

Additionally, every individual unit of configuration is placed in its own
subfolder with a `default.nix` file.


### Files

#### `config`
This contains all the non-host-specific configuration. With a chain of
workarounds and module manipulation, I've set it up such that each `default.nix`
file is automatically assigned to a set of options under the top level option
`dotfiles`, based on the file path of said `default.nix`. For lack of a better
term, I've referred to this as "bottlecapping".

For example, `config/git/default.nix` is assigned to `dotfiles.git`. By default
all bottlecapped modules are disabled, but a module can forcibly enable itself.
Additional options exist within the bottlecap system, which I might get around
to documenting sometime.

#### `tools`
A collection of files related to this configuration, but not directly used in
building it. Among others things, I keep notes in `tools/md`, for important
commands I don't use often.

#### `hosts`
Each subfolder contains configuration specific to a particular machine, the
name of which is the subfolder name.


### Operating system
This is what I imagine would be the largest hurdle for anyone trying to adopt
this configuration.

First of all, my configuration uses `impermanence`. While this isn't too
restrictive in itself, it does require some consideration when installing
certain programs. Additionally, since `/` is not persistent, the disk partition
that I assume normally would be bound to it is bound to `/nix` instead.

Second, this configuration uses a custom
[`agenix`](https://github.com/ryantm/agenix) based secrets flake. The secrets
themselves are split by host, and the secrets flake assumes that any given host
has a TPM to encrypt and decrypt secrets against. While I do plan to publish a
template of said flake in the future, I have higher priorities until then.

> [!CAUTION]
> As I understand it, since `/` is mounted as a `tmpfs`, and since `agenix`
> decrypts all host secrets to plaintext in `/run/agenix` at runtime, albeit
> access restricted, all host secrets are stored plaintext in ram. Thus, this
> configuration is probably particularly sensitive to ram exploits, like DMA
> attacks.  

Third, and really the least important, this configuration assumes that your
system is secureboot compatible and that secureboot is enabled. This stretches
a little beyond scope of NixOS dotfiles, but the disk partitions for any given
machine are assumed to be LUKS encrypted, which I've bound to be unlocked
automatically on boot by the TMP. The TMP itself checks the contents of the
boot partition and whether secureboot completed successfully before releasing
the LUKS partition key.



## Machines

### `awa`
My daily use laptop, a pretty endgame spec AMD Framework 13.

| Processor         | Graphics                | Memory    | Storage  |
| :---------------: | :---------------------: | :-------: | :------: |
| AMD Ryzen 7 7840U | Integrated Raydeon 700M | 32GB DDR5 | 1TB NVMe |


<br />


## Security / Privacy
This is more for myself, as a to-do and a to-done. If you think there's
anything listed incorrectly or is excessively (even for me) paranoid, please,
let me know.
## 

- [x] Evil maid attacks
	- [x] Secureboot
	- [x] LUKS encrypted disks, locked against the TPM with PCRs 0, 2, 7, 8
- [ ] DMA attacks
    - ~~Supposedly the firmware in `awa` will halt a boot if chassis intrusion
      is detected, but I don't know if it will shutdown
	on a detected chassis intrusion after boot.~~ Neither.
	- If not, then I probably should create a service to do so.
- [ ] Kernel modules
	- It'd probably be a good idea to blacklist certain modules
    ~~- [ ] Enable additional entropy modules?~~ Additional entropy can be
    gained through audio or visual data. For my purposes, these are not 
    available.
- [ ] General kernel and boot hardening
- [ ] Restrict access on important directories
- [x] ~~Zram~~ / Zswap to reduce the chance of swapping important data
    - [-] For an extra step, it would probably be good to also wipe all ~~swap~~
    ram on shutdown
        - I didn't realize it until now, but if swap is encrypted with a
        random key (the way its usually done), it becomes effectively 
        unrecoverable on shutdown
- [x] Encrypted swap partition
- [ ] Isolate / restrict USB and other ports
- [ ] Harden / anonymize wireless connections
    - [x] `dhcpcd` is configured with the `anonymous` flag, which implements
      [RFC 7488](https://datatracker.ietf.org/doc/html/rfc7488)
- [ ] Implement an official ProtonVPN app
	- To allow for much easier / automatic rotation of VPN host servers
	- Another option is to create a script that can fetch VPN configuations
    automatically; that'd essentially perform the same function more simply.
- [X] Whonix machine id
- [ ] Backup `secrets` flake input
    - Currently, it's just a repository that only exists on `awa`, so obviously
    I'm boned if I lose it.


<br />


## Credits
I'd like to thank these few, from which I've derived parts of my knowledge or
design.

<!-- i ripped this directly from raexera/yuki/readme -->
<!-- heys its really cool -->
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

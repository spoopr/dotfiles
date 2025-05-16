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


## Credits
I'd like to thank these few, from which I've derived parts of my knowledge or design.

<p align="center">
  <a href="https://github.com/sioodmy">sioodmy</a> - 
  <a href="https://github.com/vimjoyer">vimjoyer</a> -
  <a href="https://github.com/raexera">raexera</a> -
  <a href="https://github.com/xe">xe</a> -
  <a href="https://github.com/ryantm">ryantm</a> -
  <a href="https://github.com/qfpl">qfpl</a>
</p>

And to those I've forgotten, thank you aswell.

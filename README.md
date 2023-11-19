# NixOS System Configuration

My personal nixos configuration.


## Structure

The project is managed as a Flake. The Flake configuration consists of two files, the `./flake.nix`, specifying the inputs (dependencies) and outputs (artifacts/system configurations) of the Flake, and the `./flake.lock`, which pins every dependency and the Flake itself to a specific revision or digest, ensuring reproducibility. The outputs of the Flake are:

- `nixosConfigurations.laptop`
	
	The system configuration. The entire system configuration is defined in the file `nixos/configuration.nix` which also imports a hardware module `nixos/hardware-configuration.nix`. The hardware module is auto-generated by Nix when installing the NixOS operating system. The system configuration is mainly responsible for the components that are required to run a functional system. Any user specific software, dot-files, secrets, wallpapers, etc. should be managed by home-manager.

- `homeConfigurations.sondre@laptop`

   A stand-alone home-manager configuration. Everything that is user specific should be specified in the `home-manager/home.nix`.

## Building the system

After cloning this repository, you should change out the `nixos/hardware-configuration.nix` with your own generated file. If you have a new install of NixOS, you can copy the file located in `/etc/nixos/hardware-configuration.nix`. If needed, you can recreate the hardware-configuration with the following command:

```bash
nixos-generate-config --show-hardware-config > /etc/nixos/hardware-configuration.nix
```

We should now be ready to build the system for the first time. These commands are the same for every time we make a new change to the configuration files.

### Buildings the system configuration

```bash
sudo nixos-rebuild --flake .#laptop
```
The `.` assumes that you are in the root folder of this repo. The `#laptop` select the system configuration to build. You could potentially have many system configurations for other machines or your phone.

### Building the user configuraion

If the `home-manager` command is not available, you will need to run `nix-shell -p home-manager`.

```bash
home-manager --flake .#sondre@laptop
```

This will make home-manager build the configuration for the user `sondre` on the host `laptop`. Here, you could potentially have many configurations for different users and hosts. This configuration contains a bash alias that makes it easier to rebuild the user config (`home-switch`) from any location.

## Resources

You can browse all Nix packages and options using these two pages:

- [The official index](https://search.nixos.org/packages)
- [Mynixos for home-manager](https://mynixos.com)

### Must reads

- [One-pager on the nix language](https://github.com/tazjin/nix-1p)
- [A three-part article on Flakes](https://www.tweag.io/blog/2020-05-25-flakes/)
- [A short book on nixos and flakes](https://nixos-and-flakes.thiscute.world/)
- [Some notes about using Nix](https://github.com/justinwoo/nix-shorts)


### Tutorials and guides

- [Zero to nix. High quality step-by-step tutorials](https://zero-to-nix.com/)
- [nix.dev](https://nix.dev/index.html)


### Official docs

- [The official learning page](https://nixos.org/learn)
- [Nix pills](https://nixos.org/guides/nix-pills/)
- [The Flake wiki](https://nixos.wiki/wiki/Flakes)


### Things to watch

- [Simple and great tutorials on setting up NixOS](https://youtube.com/playlist?list=PLko9chwSoP-15ZtZxu64k_CuTzXrFpxPE&si=aLq1OKL-zAW4V2ko)
- [Some great videos on general nixOS tooling and hackery.](https://www.youtube.com/channel/UC-cY3DcYladGdFQWIKL90SQ)
- [The nix hour livestreams](https://www.youtube.com/watch?v=wwV1204mCtE&list=PLyzwHTVJlRc8yjlx4VR4LU5A5O44og9in&index=50)


### Example configurations

- [Starter template configurations](https://github.com/Misterio77/nix-starter-configs)
- [A minimalistic config for scared beginners](https://github.com/colemickens/nixos-flake-example)
- [Awesome example config](https://github.com/Misterio77/nix-config/tree/main)
- [An overengineered config to scare off beginners](https://github.com/divnix/devos)
- [Configs](https://github.com/LEXUGE/nixos) [to](https://github.com/bqv/nixrc) [shamelessly](https://git.sr.ht/~dunklecat/nixos-config/tree) [rummaged](https://github.com/utdemir/dotfiles) [through](https://github.com/purcell/dotfiles)
- [Helped me configure hyprland on a VM](https://github.com/donovanglover/nix-config/)

### Misc
- [Someone else's descent into madness](https://www.ianthehenry.com/posts/how-to-learn-nix/introduction/)
- [Generators in nix (for npm, yarn, python and haskell)](https://myme.no/posts/2020-01-26-nixos-for-development.html)

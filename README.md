# dotfiles
## OS

ubuntu 24.04

## pc setup 
- set up git/github authentication
  - generate pubkey by ssh-keygen
  - register pubkey to github
  - git clone own repository by ssh-key

- install mozc and setup japanese input source
  - `sudo apt install ibus-mozc`

- install omakubu
  - `wget -qO- https://omakub.org/install | bash`

- install nix
  - `sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon`
  - https://nixos.org/download/#download-nix

- clone this repo and exec `nix run home-manager/master -- switch --flake .#york -b backup`

- make capslock ctrl

## update flake

```
# update all flakes
$ nix flake update 

# update a flake
$ nix flake claude-codenix
```

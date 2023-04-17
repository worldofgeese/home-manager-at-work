# Home Manager at Work

To quickly bring up my Home Manager config first install Nix then

```sh
# enable Nix flake support
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
# clone my repository
git clone https://github.com/worldofgeese/home-manager-at-work ~/.config/home-manager
# bring up Home Manager config
nix run home-manager/master -- init --switch -b backup
```

Home Manager will install a suite of packages useful for work. To keep these packages updated simply run 

```sh
nix flake update ~/.config/home-manager && home-manager switch
```

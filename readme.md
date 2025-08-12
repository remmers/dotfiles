Installation
------------

``` bash
cd ~
git clone https://github.com/remmers/dotfiles.git ./dotfiles
chmod +x ./dotfiles/setup.sh
./dotfiles/setup.sh
chsh -s $(which zsh)
```

For VS Code development containers: Add below config to user settings on host. User settings from WSL are not synchronized to dev containers.

``` json
  // Dotfiles settings
  "dotfiles.repository": "https://github.com/remmers/dotfiles.git",
  "dotfiles.targetPath": "~/dotfiles",
  "dotfiles.installCommand": "setup.sh",
```

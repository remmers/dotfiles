#!/bin/bash
############################
# setup.sh
# This script sets up a new Linux machine with my preferred dotfiles.
# It creates symlinks from the home directory to the dotfiles in ~/dotfiles.
# (adapted from https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh)
############################

########## Variables

# dotfiles in ~
dir=~/dotfiles                                      # dotfiles directory
olddir=~/dotfiles_old                               # old dotfiles backup directory

# list of files/folders to symlink in homedir
files="
  .gitconfig
  .zshrc
  .p10k.zsh
"

# dotfiles for VS Code
backup_dir_vscode=~/dotfiles_old/.vscode
dotfiles_vscode_settings_path=~/dotfiles/.vscode/settings.json
vscode_settings_dir=~/.vscode-server/data/Machine
vscode_settings_path=~/.vscode-server/data/Machine/settings.json


##########

############################
# Symlinks
############################
echo "# Setup symlinks to dotfiles"

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ... "
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ... "
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory,
# then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
echo "Backup existing dotfiles from ~ to $olddir and create symlinks to the files in $dir ..."
for file in $files; do
  echo "- $file:"
  echo -n "   - move from ~/ to $olddir/"
  mv ~/$file $olddir/
  echo " ... done"
  echo -n "   - symlink from $dir to ~/"
  ln -s $dir/$file ~/$file
  echo " ... done"
done

# move and link vscode settings

echo "Backup existing vscode settings and create symlinks"
if [ ! -d "$vscode_settings_dir" ]; then
  echo " - Settings directory not found -> create ..."
  echo -n " - mkdir $vscode_settings_dir ... "
  mkdir -p $vscode_settings_dir
  echo " -> done"
else
  echo " -> Settings directory found."
fi

  echo " - settings.json:"
  echo -n "   - move from $vscode_settings_dir to $backup_dir_vscode"
  mv $vscode_settings_path $backup_dir_vscode
  echo " ... done"
  echo -n "   - symlink from $dotfiles_dir_vscode to ~/"
  ln -s $dotfiles_vscode_settings_path $vscode_settings_path
  echo " ... done"

############################
# ZSH
############################
echo "# Setup zsh"
echo "Install zsh"
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
  echo " -> zsh is already installed"
else
  echo " - apt-get install zsh"
  # sudo apt-get install zsh
  echo " -> done"
fi
# Set the default shell to zsh if it isn't currently set to zsh
echo "Set as default"
if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
  echo " - chsh -s $(which zsh)"
  # chsh -s $(which zsh)
  echo " -> done"
fi

############################
# oh-my-zsh
############################
echo "# Setup oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo -n " -> Cloning oh-my-zsh ..."
  # git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  echo " -> done"
else
  echo " -> oh-my-zsh is already present"
fi
echo "# Setup oh-my-zsh theme powerlevel10k"
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
  echo -n " -> Cloning powerlevel10k ... "
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
  echo " -> done"
  echo -n " -> Restarting zsh ... "
  exec zsh
  echo " -> done"
else
  echo " -> powerlevel10k is already present"
fi

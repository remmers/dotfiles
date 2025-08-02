#!/bin/bash
############################
# setup.sh
# This script sets up a new Linux machine with my preferred dotfiles.
# It creates symlinks from the home directory to the dotfiles in ~/dotfiles.
# (adapted from https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh)
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory

# list of files/folders to symlink in homedir
files="
  .gitconfig
  .zshrc
  .p10k.zsh
"
# files="bashrc vimrc vim oh-my-zsh private scrotwm.conf Xresources"    # list of files/folders to symlink in homedir

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
echo "Moving any existing dotfiles from ~ to $olddir and creating symlinks to the files in $dir ..."
for file in $files; do
  echo "- $file:"
  echo -n "   - move from ~/ to $olddir/"
  mv ~/$file $olddir/
  echo " ... done"
  echo -n "   - symlink from $dir to ~/"
  ln -s $dir/$file ~/$file
  echo " ... done"
done

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
  echo " -> Cloning oh-my-zsh"
  # git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  echo " -> done"
else
  echo " -> oh-my-zsh is already present"
fi

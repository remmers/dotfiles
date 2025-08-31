#!/bin/bash
############################################
# setup.sh
# This script sets up a new Linux machine with preferred dotfiles.
# It creates symlinks from the home directory to the dotfiles in ~/dotfiles.
# (adapted from https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh)
############################################


############################################
# Variables
############################################

# dotfiles in ~
dotfiles_dir=~/dotfiles        # dotfiles directory
backup_dir=~/dotfiles_old      # old dotfiles backup directory
zsh_installed=false            # set to true if zsh is installed

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

############################################
# Symlinks for dotfiles
############################################
echo ""
echo "############################"
echo "# Setup dotfiles"
echo "############################"
echo ""

# create dotfiles_old in homedir
echo "- Creating backup directory for any existing dotfiles in ~"
echo "  -> 'mkdir -p $backup_dir' ... "
mkdir -p $backup_dir
# change to the dotfiles directory
echo "- Changing to the $dotfiles_dir directory"
cd $dotfiles_dir

# move any existing dotfiles in homedir to dotfiles_old directory,
# then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
echo "- Backup existing dotfiles from '~' to '$backup_dir' and create symlinks to the files in '$dotfiles_dir'"
for file in $files; do
  echo "  - $file:"
  echo "    -> 'mv ~/$file $backup_dir/'"
  mv ~/$file $backup_dir/
  echo "    -> 'ln -s $dotfiles_dir/$file ~/$file'"
  ln -s $dotfiles_dir/$file ~/$file
done

# move and link vscode settings
echo "- Backup existing vscode settings and create symlinks"
if [ ! -d "$vscode_settings_dir" ]; then
  echo "  - Settings directory not found -> create it"
  echo "    -> 'mkdir -p $vscode_settings_dir'"
  mkdir -p $vscode_settings_dir
else
  echo "  - Settings directory "$vscode_settings_dir" found."
fi

echo "  - settings.json:"
echo "    -> 'mv $vscode_settings_path $backup_dir_vscode'"
mv $vscode_settings_path $backup_dir_vscode
echo "    -> 'ln -s $dotfiles_vscode_settings_path $vscode_settings_path'"
ln -s $dotfiles_vscode_settings_path $vscode_settings_path

############################################
# Local user data
############################################
echo ""
echo "############################"
echo "# Local user data"
echo "############################"
echo ""

# .local directory, e.g. for zsh history
echo "- Creating directory for local user data, e.g. zsh history"
if [ ! -d "$HOME/.local_user_data" ]; then
  echo "  -> 'mkdir -p $HOME/.local_user_data'"
  mkdir -p $HOME/.local_user_data
else
  echo "  -> Directory ~/.local_user_data already exists"
fi

############################################
# ZSH
############################################
echo ""
echo "############################"
echo "# Setup ZSH"
echo "############################"
echo ""

echo "- Check installation of zsh"
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
  zsh_installed=true
  echo "  -> zsh is installed"
else
  zsh_installed=false
  echo "  -> ERROR: zsh is NOT installed!"
  echo "  -> install with"
  echo "     'sudo apt install zsh'"
fi

echo "- Download oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "  -> 'git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git \"$HOME/.oh-my-zsh\"'"
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
else
  echo "  -> oh-my-zsh is already installed in $HOME/.oh-my-zsh"
fi

echo "- Download oh-my-zsh themes/plugins"

  echo "  - theme powerlevel10k"
  if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "    -> 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \"$HOME/.oh-my-zsh/custom/themes/powerlevel10k\"'"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
  else
    echo "    -> Theme powerlevel10k is already present"
  fi
  echo "  - plugin autosuggestions"
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "    -> 'git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions'"
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  else
    echo "    -> Plugin zsh-autosuggestions is already present"
  fi

############################################
# Complete, manual activities
############################################

echo -e "\n\n"
echo "############################"
echo ""
echo "-> Automatic setup completed."
echo ""
echo "Manual activities:"

if [ "$zsh_installed" = false ]; then
  echo "- Install zsh with:"
  echo "  'sudo apt install zsh'"
fi

# Reminder to set zsh as default shell
echo "- Set zsh as default shell with:"
echo "  'chsh -s $(which zsh)'"

# Disabled restart, does not seem to work properly with dev containers
echo "- Restart zsh with:"
echo "  'exec zsh'"

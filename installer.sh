#!/bin/bash

### This is for if you are NOT root and want to install zsh and powershell10k theme as NOT root.

important_note="NOTE: You are about to install ncurses, Zsh, Oh My Zsh, and powerlevel10k.

1. ncurses -  a shell manager and will be used to install the other software, because you might not have root access.
2. Zsh - the shell you want.
3. Oh My Zsh - like Zsh++, its a wrapper and improvement on Zsh.
4. Powerlevel10k - a very nice theme.

During the program installation process you will be asked prompts.
If it says if you want Zsh as your default shell, say yes (y), then exit (cntrl+D)
Then the installation will continue.

>> Do you acknowledge and read the above? [y, n]"
echo "$important_note"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    echo ">> Acknowledged. Continuing on with installation..." && sleep 5
else
    echo ">> Not Acknowledged. Stopping execution..." && exit;
fi

## STEP 1. Create software directory
export software=$HOME/software
if [ -d $software ]
then
    cd $software
else
    mkdir $software && cd $software && echo ">> Created directory: $software" & sleep 10
fi

## STEP 2. Install a shell manager (since you are not root)
# Download the ncurses gzipped tarball
echo ">>Downloading ncurses - a shell manager, useful if you do not have root accesss"
curl https://invisible-island.net/archives/ncurses/ncurses-6.1.tar.gz -o $software/ncurses-6.1.tar.gz
echo ">> Downloaded ncurses"
sleep 10
echo ">> Installing ncurses..."
sleep 10

# Extract gzipped tarball
tar -zxvf ncurses-6.1.tar.gz

# Move into root ncurses source directory
cd ncurses-6.1

# Set cflags and c++ flags to compile with Position Independent Code enabled
export CXXFLAGS=' -fPIC'
export CFLAGS=' -fPIC'

# Produce Makefile and config.h via config.status
./configure --prefix=$HOME/.local --enable-shared

# Compile
make install

# Deduce environment information and build private terminfo tree
cd progs
./capconvert
cd ..

# Optional TEST if ncurses was install correctly (press control+C to exit):
# $software/ncurses-6.1/test/ncurses

# Install ncurses to $HOME/.local
make install
echo ">> ncurses installed!"
sleep 10


### STEP 3. Install Zsh
# Tell it where ncurses lives
echo ">> Downloading Zsh"
INSTALL_PATH="$HOME/.local"

export PATH=$INSTALL_PATH/bin:$PATH
export LD_LIBRARY_PATH=$INSTALL_PATH/lib:$LD_LIBRARY_PATH
export CFLAGS=-I$INSTALL_PATH/include
export CPPFLAGS="-I$INSTALL_PATH/include" LDFLAGS="-L$INSTALL_PATH/lib"

# download and install zsh
curl https://www.zsh.org/pub/zsh-5.9.tar.xz -o $software/zsh-5.9.tar.xz
echo ">> Downloaded Zsh, now installing..."
sleep 10
tar -xvf $software/zsh-5.9.tar.xz
cd $software/zsh-5.9
./Util/preconfig
./configure --prefix=$HOME/.local --enable-shared
make
make install

echo ">> Installed Zsh"
sleep 10
#
## STEP 4. Install Oh My Zsh
## https://ohmyz.sh/
#
#
echo ">> Downloading and Installing Oh My Zsh"
cd $software
# If $HOME/.oh-my-zsh already exists, we'll rename it .._old and then continue on.
if [ -d $HOME/.oh-my-zsh ]
then
    mv $HOME/.oh-my-zsh $HOME/.oh-my-zsh_old && echo "Found an old .oh-my-zsh folder in $HOME, renameed to $HOME/.oh-my-zsh_old"
fi
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo ">> Downloaded and Installed Oh My Zsh"
sleep 10
#
## Install Powerlevel10k
## https://github.com/romkatv/powerlevel10k
echo ">> Downloading and Installing the powerlevel10k theme for Oh My Zsh"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# Replace the default ZSH_THEME="robbyrusselll" with ZSH_THEME="powerlevel10k/powerlevel10k"
sed -i 's|robbyrussell|powerlevel10k/powerlevel10k|g' .zshrc
echo ">> DONE!!!"
sleep 5

robbyrussell

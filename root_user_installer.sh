#!/bin/bash

### This is for if you are root and want to install zsh and powershell10k theme.

important_note="NOTE: You are about to install Oh My Zsh and powerlevel10k.

1. Oh My Zsh - like Zsh++, its a wrapper and improvement on Zsh.
2. Powerlevel10k - a very nice theme.

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

## Install Oh My Zsh
# https://ohmyz.sh/#install
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## Install Powerlevel10k
# https://github.com/romkatv/powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

## Set the Zsh theme to powerlevel10k
sed -i'.bak' "s|robbyrussell|powerlevel10k/powerlevel10k|g" $HOME/.zshrc

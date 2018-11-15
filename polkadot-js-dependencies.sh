#!/usr/bin/env bash

prompt_install () {
  while true; do
  	echo
    read -p "Proceed with installing $1 (Y/N)? > " yn
    case $yn in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
      * ) echo
					echo "Try again. Please answer yes or no.";;
    esac
  done
}

echo
echo -e "\e[39mPolkadot-JS Dependencies Setup...";

APP="Xcode Command Line Tools"
echo
echo -e "\e[35mSearching for $APP...\e[37m";
if xcode-select --install 2>&1 | grep installed; then
	echo -e "  Skipping, $APP already installed";
else
	if prompt_install $APP; then
		echo -e "  Installing $APP...";
		xcode-select --install;
	fi
fi

APP="Homebrew"
echo
echo -e "\e[35mSearching for $APP...\e[37m";
if brew 2>&1 | grep Example; then
	echo -e "  Skipping, $APP already installed";
else
	if prompt_install $APP; then
		echo -e "  Installing $APP...";
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
	  export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
	  brew doctor
	  brew update
	fi
fi

APP="RBenv"
echo
echo -e "\e[35mSearching for $APP...\e[37m";
if rbenv 2>&1 | grep Usage; then
	echo -e "  Skipping, $APP already installed";
else
	if prompt_install $APP; then
		echo -e "  Installing $APP...";
		brew install rbenv;
		rbenv init;
		echo -e 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile;
		source ~/.bash_profile;
		echo -e "  Installing Ruby latest version: $(rbenv install -l | grep -v - | tail -1)"
		rbenv install $(rbenv install -l | grep -v - | tail -1);
	  echo -e "  Switching to use Ruby latest version";
		rbenv global $(rbenv install -l | grep -v - | tail -1);
	fi
fi

APP="Node Version Manager (NVM)"
echo
echo -e "\e[35mSearching for $APP...\e[37m";
if nvm 2>&1 | grep Manager; then
	echo -e "  Skipping, $APP already installed";
else
	if prompt_install $APP; then
		echo -e "  Installing $APP...";
		curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash;
		export NVM_DIR="$HOME/.nvm"
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
		[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
		echo -e "  Installing Node.js latest LTS version";
		nvm install --lts
		echo -e "  Switching to use Node.js latest LTS version";
		nvm use --lts;
	fi
fi

APP="Yarn"
echo
echo -e "\e[35mSearching for $APP...\e[37m";
if yarn 2>&1 | grep install; then
	echo -e "  Skipping, $APP already installed";
else
	if prompt_install $APP; then
		echo -e "  Installing $APP latest version...";
		brew install yarn --without-node;
	fi
fi

APP="Git"
echo
echo -e "\e[35mSearching for $APP...\e[37m";
if git 2>&1 | grep usage; then
	echo -e "  Skipping, $APP already installed";
else
	if prompt_install $APP; then
		echo -e "  Installing $APP latest version...";
		brew install git; brew upgrade git;
		git config --global color.ui auto;
		echo -e "  Please enter your username for $APP Config:";
		read -p "    Username > " uservar
		echo -e "  Please enter your email for $APP Config:";
		read -p "    Email >" emailvar
		git config --global user.name "$uservar";
		git config --global user.email "$emailvar";
		echo
		echo -e "  $APP Config updated with your credentials";
	fi
fi

APP="Docker"
echo
echo -e "\e[35mSearching for $APP...\e[37m";
if docker 2>&1 | grep Usage; then
	echo -e "  Skipping, $APP already installed";
else
	if prompt_install $APP; then
		echo -e "  Installing Homebrew Cask";
		echo
		brew tap caskroom/cask;
		echo -e "  Installing $APP latest version...";
		CASKS=(
			docker
		);
		brew cask install --appdir="/Applications" ${CASKS[@]}
	fi
fi

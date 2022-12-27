#!/bin/bash
## For Fedora, Rocky, CentOS
##INIT S.
bold=$(tput bold)
normal=$(tput sgr0)
##INIT E.

echo "${bold}0. Change Mirror${normal}"
	if [ -f /etc/fedora-release ]; then
		echo "${bold}********************"
		echo "Fedora Detected"
		echo "********************${normal}"
		echo "Change mirror >>> KAIST"
    		## Init.
			BASE_REPOS=/etc/yum.repos.d/fedora.repo
			KAIST="ftp.kaist.ac.kr\/fedora"
			REPOS=${KAIST}
			releasever=$(cat /etc/fedora-release | tr -dc '0-9.'|cut -d \. -f1)
			basearch=x86_64
			FULL_REPOS="http:\/\/${REPOS}\/${releasever}\/BaseOS\/${basearch}\/os"
			## Process
			sudo sed  -i.bak -re "s/^(mirrorlist(.*))/##\1/g" -re "s/[#]*baseurl(.*)/baseurl=${FULL_REPOS}/" ${BASE_REPOS} 
			## Update
			sudo yum repolist baseos -v

	elif [ -f /etc/rocky-release ]; then
		echo "${bold}********************"
		echo "Rocky Linux Detected"
		echo "********************${normal}"
		echo "Change mirror >>> NAVER"
			## Init.
				REPOS_FILES="AppStream BaseOS"
				NAVER="mirror.navercorp.com\/rocky"
				REMOTE_REPOS=${NAVER}
				releasever=$(cat /etc/redhat-release | tr -dc '0-9.'|cut -d \. -f1)
				basearch=x86_64
				for i in ${REPOS_FILES};do
				R="/etc/yum.repos.d/Rocky-${i}.repo";
				FULL_REPOS_PATH="http:\/\/${REMOTE_REPOS}\/${releasever}\/${i}\/${basearch}\/os"
			## Process
				sudo sed  -i.bak -re "s/^(mirrorlist(.*))/##\1/g" -re "s/[#]*baseurl(.*)/baseurl=${FULL_REPOS_PATH}/" ${R}
			done
			## Update
				sudo yum check-update
				sudo yum repolist baseos -v
				sudo yum repolist appstream -v
			## Check
				echo "${bold}**********************************************************"
				echo "************************!RESULT!**************************"
				sudo yum repolist baseos -v | grep navercorp
				echo "************************!!PASS!!**************************"
				echo "**********************************************************${normal}"
			sudo dnf install -y epel-release dnf-plugins-core
			sudo dnf config-manager --set-enabled powertools 

	elif [ -f /etc/centos-release ]; then
		echo "${bold}********************"
		echo "CentOS Detected"
		echo "********************${normal}"
		echo "Change mirror >>> NAVER"
			sudo sed  -i.bak -re "s/^(mirrorlist(.*))/##\1/g" -re "s/[#]*baseurl(.*)/baseurl=http:\/\/mirror.navercorp.com\/centos\/$(cat /etc/centos-release | tr -dc '0-9.'|cut -d \. -f1)\/BaseOS\/x86_64\/os/" /etc/yum.repos.d/CentOS-Linux-BaseOS.repo
		## Update
			sudo yum update
		## Check
				echo "${bold}**********************************************************"
				echo "************************!RESULT!**************************"
				sudo yum repolist baseos -v | grep navercorp
				echo "************************!!PASS!!**************************"
				echo "**********************************************************${normal}"
		sudo dnf install -y epel-release 
	
	else 
	echo "Failed to Change Mirror"
	echo "Skipping..."
	fi
echo ""

echo "${bold}1. Update and Install Packages${normal}" 
	sudo dnf upgrade -y
	sudo dnf install -y --skip-broken gnome-tweaks htop make git
	if [ -f /etc/fedora-release ]; then
		echo "${bold}********************"
		echo "Fedora Detected"
		echo "********************${normal}"
		sudo dnf install -y alien
		wget https://installer-whale.pstatic.net/downloads/installers/naver-whale-stable_amd64.deb
		sudo alien -r naver-whale-stable_amd64.deb
		sudo rpm -Uvh --force naver-*.rpm
		sudo sed -i 's|Icon=naver-whale|Icon=/opt/naver/whale/product_logo_256.png|g' /usr/share/application/naver-whale.desktop

	elif [ -f /etc/rocky-release ]; then
		echo "${bold}********************"
		echo "Rocky Linux Detected"
		echo "********************${normal}"
		sudo dnf install -y alien
		wget https://installer-whale.pstatic.net/downloads/installers/naver-whale-stable_amd64.deb
		sudo alien -r naver-whale-stable_amd64.deb
		sudo rpm -Uvh --force naver-*.rpm
		sudo sed -i 's|Icon=naver-whale|Icon=/opt/naver/whale/product_logo_256.png|g' /usr/share/application/naver-whale.desktop
	else
		echo "${bold}**********************************************************"
		echo "************************!!SKIP!!**************************"
		echo "Can't install some packages because of package dependencies"
		echo "************************!!SKIP!!**************************"
		echo "**********************************************************${normal}"
	fi
echo ""

echo "${bold}2. Install fastfetch from Github${normal}"
    git clone https://github.com/LinusDierheimer/fastfetch
    cd fastfetch && mkdir -p build && cd build
    cmake .. && cmake --build . --target fastfetch --target flashfetch && sudo cmake --install . --prefix /usr/local
    cd ../../  && mkdir -p ~/.fastfetch && echo ""

echo "${bold}3. Install VSCode from MS YUM_Repo${normal}"
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
	sudo dnf check-update && sudo dnf upgrade
	sudo dnf install -y code
	echo ""

echo "${bold}4. Customize .bashrc${normal}"
	wget https://raw.githubusercontent.com/kimlulz/dotfiles/main/zsh/preset -P ~/.fastfetch && wget https://raw.githubusercontent.com/kimlulz/dotfiles/main/zsh/pepe2.ascii -P ~/.fastfetch
    echo "PS1='\[\e[0m\][\[\e[0;1;91m\]\u\[\e[0m\]|\[\e[0;1m\]$?\[\e[0m\]] \[\e[0;1;3;4m\]\w\[\e[0m\] \[\e[0;92m\]\$ \[\e[0m\]'" > ~/.bashrc && echo "fastfetch --load-config .fastfetch/preset -l ~/.fastfetch/pepe2.ascii" >> ~/.bashrc && echo ""

echo "${bold}5. Clean${normal}"
echo ""
sudo rm -rf ./neofetch
if [ -f /opt/naver/whale/whale ]; then
	sudo dnf remove -y firefox*	
	sudo rm -rf ./naver-whale-stable*
else
	sudo rm -rf ./naver-whale-stable*
fi
echo ""

source ~/.bashrc

#!/bin/bash
## For Fedora, Rocky
BL=$(tput bold)
NRM=$(tput sgr0)

function becho {
	>&2 echo -n "$BL$1$NRM"
    echo ""
}

inszsh(){
	sudo dnf install zsh
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	chsh -s /usr/bin/zsh
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
	zsh test
	wget https://github.com/kimlulz/dotfiles/blob/main/zsh/.zshrc && mv .zshrc /home/$USER/.zshrc
	echo "fastfetch -c /home/$USER/.fastfetch/13.jsonc" >> .zshrc
}

inswhale(){
	if [ -f /etc/fedora-release ]; then
		becho "********************"
		becho "Fedora Detected"
		becho "********************"
		sudo dnf install -y perl
		sudo dnf install -y alien
		wget https://installer-whale.pstatic.net/downloads/installers/naver-whale-stable_amd64.deb
		sudo alien -r naver-whale-stable_amd64.deb
		sudo rpm -Uvh --force naver-*.rpm
		sudo sed -i 's|Icon=naver-whale|Icon=/opt/naver/whale/product_logo_256.png|g' /usr/share/application/naver-whale.desktop

	elif [ -f /etc/rocky-release ]; then
		becho "********************"
		becho "Rocky Linux Detected"
		becho "********************"
		becho "Can't install on rocky linux"
		becho "It still wip... pass..."
	else
		becho "**********************************************************"
		becho "************************!!SKIP!!**************************"
		becho "Can't install some packages because of package dependencies"
		becho "************************!!SKIP!!**************************"
		becho "**********************************************************"
	fi
}

echo "" && echo -e "\033[31m"The location of mirror is based on Korea."\033[0m"
echo -e "\033[31m"If you want to use it in another country, please change it yourself!!"\033[0m" && echo "" && sleep 5
becho "0. 🌍 Change Mirror"
echo -e "\033[31m"CentOS is no longer supported!!!"\033[0m"
	if [ -f /etc/fedora-release ]; then
		becho "********************"
		becho "Fedora Detected"
		becho "********************"
		becho "Change mirror >>> KAIST"
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
		becho "********************"
		becho "Rocky Linux Detected"
		becho "********************"
		becho "Change mirror >>> NAVER"
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
				becho "**********************************************************"
				becho "************************!RESULT!**************************"
				sudo yum repolist baseos -v | grep navercorp
				becho "************************!!PASS!!**************************"
				becho "**********************************************************"
			sudo dnf install -y epel-release dnf-plugins-core
			sudo dnf config-manager --set-enabled powertools
	else 
	echo "Failed to Change Mirror"
	echo "Skipping..."
	fi
echo ""

becho "1. ⬆️ Update and Install Packages" 
	sudo dnf upgrade -y && sudo dnf install -y --skip-broken gnome-tweaks htop make cmake git && echo ""
	becho "😎 Install Browser...?"
	sleep 5
	becho "*************************************************"
    becho "(1) [FEDORA ONLY] Install Naver Whale (Chromium-based browser made by NAVER(Korea)" 
	becho "(2) Install Chromium"
    becho "(4) No, Just use Firefox"
    becho "*************************************************"
    becho "[1/2/3] > " ; read IB
	if [ $IB = "1" ]; then
        becho "🐋 Install Naver Whale..." && sleep 5
		inswhale
		echo ""
    elif [ $IB = "2" ]; then
        becho "🟢 Install chromium..." && sleep 5
        sudo dnf install -y chromium
		echo ""
    else
        echo "PASS"
		echo ""
        fi
echo ""

becho "2. 🛠️ Build Fastfetch"
    git clone https://github.com/LinusDierheimer/fastfetch
    cd fastfetch && mkdir -p build && cd build
    cmake .. && cmake --build . --target fastfetch --target flashfetch && sudo cmake --install . --prefix /usr/local
    cd ../../  && mkdir -p ~/.fastfetch && echo ""

becho "3. 🧑‍💻 Install VSCode from MS YUM_Repo"
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
	sudo dnf check-update && sudo dnf upgrade
	sudo dnf install -y code
	echo ""

becho "4. ⌨️ Shell Customization"
	echo "Get Preset for fastfetch"
	wget https://raw.githubusercontent.com/fastfetch-cli/fastfetch/refs/heads/dev/presets/examples/13.jsonc -P ~/.fastfetch
	echo "Modify .bashrc..."
    echo "PS1='\[\e[0m\][\[\e[0;1;91m\]\u\[\e[0m\]|\[\e[0;1m\]$?\[\e[0m\]] \[\e[0;1;3;4m\]\w\[\e[0m\] \[\e[0;92m\]\$ \[\e[0m\]'" > ~/.bashrc && echo "fastfetch -c /home/$USER/.fastfetch/13.jsonc" >> /home/$USER/.bashrc && echo ""
    echo ""

	becho "😎 Install ZSH...?"
	sleep 5
	becho "*************************************************"
    becho "(1) Install ZSH and ZPlug" 
    becho "(2) DO NOT INSTALL ZSH"
    becho "*************************************************"
    becho "[1/2] > " ; read ZS
	if [ $ZS = "1" ]; then
    	becho "😎 Install ZSH..." && sleep 3
		inszsh
		echo ""
    elif [ $ZS = "2" ]; then
    	echo "PASS"
		echo ""
    else
        echo "PASS"
		echo ""
	fi

becho "5. 🗑️ Clean"
echo ""
if [ -f /opt/naver/whale/whale ]; then
	sudo rm -rf ./naver-whale-stable*
	sudo rm -rf ./fastfetch
else
	sudo rm -rf ./fastfetch
fi
echo ""

becho "🥳 Finished. Reboot now? [y / n or any key]"
		echo -n "${b}> ${n}" ;read yn
		if [ $yn = "y" -o $yn = "Y" ]; then
			reboot
		else 
			echo "Finished!"
			echo "Need to reboot manually"
			exit
		fi

#!/bin/bash
BL=$(tput bold)
NRM=$(tput sgr0)
el_ver=$(cat /etc/redhat-release | tr -dc '0-9.' | cut -d '.' -f1)


function becho {
	echo -e "${BL}$1${NRM}"
    echo ""
}

mirch(){
	if [ -f /etc/fedora-release ]; then
		becho "********************"
		becho "Fedora Detected"
		becho "********************"
		fedorepo

	elif [ -f /etc/rocky-release ]; then
		becho "********************"
		becho "Rocky Linux Detected"
		becho "********************"
		rockyrepo
	
	elif [ -f /etc/almalinux-release ]; then
		becho "********************"
		becho "AlmaLinux Detected"
		becho "********************"
		almarepo

	else 
		becho "Failed to Change Mirror"
		becho "Skipping..."
	fi
echo ""
}

fedorepo(){
	echo "Change mirror >>> KRFOSS"
    		## Init.
			BASE_REPOS=/etc/yum.repos.d/fedora.repo
			KAIST="mirror.krfoss.org\/fedora"
			REPOS=${KAIST}
			releasever=$(cat /etc/fedora-release | tr -dc '0-9.'|cut -d \. -f1)
			basearch=x86_64
			FULL_REPOS="http:\/\/${REPOS}\/${releasever}\/BaseOS\/${basearch}\/os"
			## Process
			sudo sed  -i.bak -re "s/^(mirrorlist(.*))/##\1/g" -re "s/[#]*baseurl(.*)/baseurl=${FULL_REPOS}/" ${BASE_REPOS} 
			## Update
			sudo yum repolist baseos -v
}

rockyrepo(){
	becho "Change mirror >>> NAVER"
	rocky_version=$(grep -oP '\d+' /etc/rocky-release | head -1)
    if [[ "$rocky_version" =~ 8 ]]; then
        becho "Rocky Linux 8 Detected"
				REPOS_FILES="AppStream BaseOS"
				REMOTE_REPOS="mirror.navercorp.com\/rocky"
				releasever=$(cat /etc/redhat-release | tr -dc '0-9.'|cut -d \. -f1)
				basearch=x86_64
				for i in ${REPOS_FILES};do
				R="/etc/yum.repos.d/Rocky-${i}.repo";
				FULL_REPOS_PATH="http:\/\/${REMOTE_REPOS}\/${releasever}\/${i}\/${basearch}\/os"
				sudo sed  -i.bak -re "s/^(mirrorlist(.*))/##\1/g" -re "s/[#]*baseurl(.*)/baseurl=${FULL_REPOS_PATH}/" ${R}
			done
				sudo yum check-update
				sudo yum repolist baseos -v
				sudo yum repolist appstream -v
				becho "**********************************************************"
				becho "************************!RESULT!**************************"
				sudo yum repolist baseos -v | grep navercorp
				becho "************************!!PASS!!**************************"
				becho "**********************************************************"
			sudo dnf install -y epel-release dnf-plugins-core
			sudo dnf config-manager --set-enabled powertools
	elif [[ "$rocky_version" =~ ^(9|10)$ ]]; then 
	#elif (( "$rocky_version" >= 9 )); then #If newer repo file structure is same with el9
		REPO_FILE="/etc/yum.repos.d/rocky.repo"
		REMOTE_REPOS="mirror.navercorp.com/rocky"
		releasever=$(rpm -q --qf "%{VERSION}" rocky-release | cut -d '.' -f1)
		basearch=x86_64
		REPO_IDS=("BaseOS" "AppStream")
		becho "Rocky Linux $releasever Detected"
			for repo_id in "${REPO_IDS[@]}"; do
    			repo_id_lower=$(echo "$repo_id" | tr '[:upper:]' '[:lower:]')
    			FULL_REPO_PATH="http://${REMOTE_REPOS}/${releasever}/${repo_id}/${basearch}/os"
    			sudo sed -i.bak -e "/^\[${repo_id_lower}\]/,/^\[/{ 
        		s/^mirrorlist/#mirrorlist/ 
        		s|^#*baseurl=.*|baseurl=${FULL_REPO_PATH}|
    			}" "$REPO_FILE"
			done
			sudo dnf clean all
			sudo dnf makecache
			sudo dnf repolist "$repo_id" -v
			becho "**********************************************************"
			becho "************************!RESULT!**************************"
			sudo yum repolist baseos -v | grep navercorp
			becho "************************!!PASS!!**************************"
			becho "**********************************************************"
		sudo dnf install -y epel-release dnf-plugins-core
		sudo dnf config-manager --set-enabled crb
    else
        becho "It seems you are using an unsupported distro."
        becho "Exit..."
        exit
    fi		
}

almarepo(){
	becho "Change mirror >>> KRFOSS"
	alma_version=$(grep -oP '\d+' /etc/almalinux-release | head -1)
	REPOS_FILES="appstream baseos"
	REMOTE_REPOS="mirror.krfoss.org\/almalinux"
	releasever=$(cat /etc/redhat-release | tr -dc '0-9.'|cut -d \. -f1)
	basearch=x86_64
	for i in ${REPOS_FILES}; do
    R="/etc/yum.repos.d/almalinux-${i}.repo"
    case "$i" in
        appstream) CAP_NAME="AppStream" ;;
        baseos) CAP_NAME="BaseOS" ;;
        *) echo "Unknown repository: $i" ; continue;;
    esac
    FULL_REPOS_PATH="https:\/\/${REMOTE_REPOS}\/${releasever}\/${CAP_NAME}\/${basearch}\/os"
    sudo sed -i.bak \
        -re "s/^(mirrorlist.*)/##\1/g" \
        -re "s|[# ]*baseurl=.*|baseurl=${FULL_REPOS_PATH}|" \
        "${R}"
done


	sudo yum check-update
	sudo yum repolist baseos -v
	sudo yum repolist appstream -v
	becho "**********************************************************"
	becho "************************!RESULT!**************************"
	sudo yum repolist baseos -v | grep krfoss
	becho "************************!!PASS!!**************************"
	becho "**********************************************************"
	sudo dnf install -y epel-release dnf-plugins-core
	if [[ "$alma_version" =~ 8 ]]; then
    	sudo dnf config-manager --set-enabled powertools
	elif [[ "$alma_version" =~ ^(9|10)$ ]]; then 
		sudo dnf config-manager --set-enabled crb
    else
    	becho "Powertools/CRB Not found"
    fi	
}

inszsh(){
	sudo dnf install -y zsh
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	chsh -s /usr/bin/zsh
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
	echo ""
	becho "*********************************************"
	becho "ZSH will turn on because of initialization."
	becho "TYPE EXIT!!!!!"
	becho "*********************************************"
	zsh 
	becho "🤔 Install Fonts"
	wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P /home/$USER/.local/share/fonts
	wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P /home/$USER/.local/share/fonts
	wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P /home/$USER/.local/share/fonts
	wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P /home/$USER/.local/share/fonts
	fc-cache -f -v && echo ""
	wget https://raw.githubusercontent.com/kimlulz/dotfiles/refs/heads/main/zsh/.zshrc
	echo "fastfetch -c /home/$USER/.fastfetch/13.jsonc" >> .zshrc && mv .zshrc /home/$USER/.zshrc && echo ""
	becho "*********************************************"
	becho "[ZPlug]"
	becho "Powerlevel10k Installed"
	becho "So, you need to change font manually through your console/terminal setting"
	becho "System fonts -> MesloLGS_NF"
	becho "*********************************************"
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
		sudo sed -i 's|Icon=naver-whale|Icon=/opt/naver/whale/product_logo_256.png|g' /usr/share/applications/naver-whale.desktop

	elif [[ "$el_ver" =~ ^(8|9)$ ]]; then 
		becho "********************"
		becho "Enterprise Linux ($el_ver) Detected"
		becho "********************"
		sudo dnf install -y --enablerepo=epel alien
		wget https://installer-whale.pstatic.net/downloads/installers/naver-whale-stable_amd64.deb
		sudo alien -r naver-whale-stable_amd64.deb
		sudo rpm -Uvh --force naver-*.rpm
		sudo sed -i 's|Icon=naver-whale|Icon=/opt/naver/whale/product_logo_256.png|g' /usr/share/applications/naver-whale.desktop

	elif [ "$el_ver" = "10" ]; then
		becho "********************"
		becho "Enterprise Linux (10) Detected"
		becho "********************"
		sudo dnf install -y perl
		sudo dnf install -y --enablerepo=crb debhelper dpkg rpm-build
		wget https://dl.fedoraproject.org/pub/epel/9/Everything/x86_64/Packages/a/alien-8.95-14.el9.noarch.rpm
		sudo rpm -Uvh --nodeps alien-8.95-14.el9.noarch.rpm #with nodeps opt, cuz it occured perl(:MODULE_COMPAT_5.32.1) error which it can igrone
		wget https://installer-whale.pstatic.net/downloads/installers/naver-whale-stable_amd64.deb
		sudo alien -r naver-whale-stable_amd64.deb
		sudo dnf install -y double-conversion qt5-filesystem qt5-qtbase \
		qt5-qtbase-common qt5-qtbase-gui qt5-qtdeclarative qt6-filesystem \
		qt6-qtbase qt6-qtbase-common qt6-qtbase-gui qt6-qtdeclarative qt6-qtsvg \
		xcb-util-cursor xcb-util-image xcb-util-keysyms xcb-util-renderutil xcb-util-wm #deps for whale
		sudo rpm -Uvh --force naver-*.rpm
		sudo sed -i 's|Icon=naver-whale|Icon=/opt/naver/whale/product_logo_256.png|g' /usr/share/applications/naver-whale.desktop
	else
		echo "Can't detect your distro"
		echo "Pass..." 
	fi
}

echo -e "\033[31m"CentOS is no longer supported!!!"\033[0m"
becho "0. 🌍 Change Mirror"
sleep 2
	becho "*************************************************"
    becho "(1) Using KR Mirror (KRFOSS for Fedora, Alma / Naver for Rocky)" 
    becho "(2) Using Default Mirror"
    becho "*************************************************"
    becho "[1/2] > " ; read CMKR
	if [ $CMKR = "1" ]; then
		echo "Using KR mirror..."
    	mirch
    elif [ $CMKR = "2" ]; then
    	echo "Using default mirror..."
		echo ""
    else
        echo "Using default mirror..."
		echo ""
	fi

becho "1. ⬆️ Update and Install Packages" 
	sudo dnf upgrade -y && sudo dnf install -y --skip-broken gnome-tweaks htop make cmake git && echo ""
becho "😎 Install Browser...?"
	sleep 2
	becho "*************************************************"
    becho "(1) Install Naver Whale (Chromium-based browser made by NAVER(Korea)" 
	becho "(2) Install Chromium"
	becho "(3) Install Another Browser (Type)"
    becho "(4) No, Just use Firefox"
    becho "*************************************************"
    becho "[1/2/3/4] > " ; read IB
	if [ $IB = "1" ]; then
        becho "🐋 Install Naver Whale..." && sleep 5
		inswhale
		echo ""
    elif [ $IB = "2" ]; then
        becho "🟢 Install chromium..." && sleep 5
        sudo dnf install -y chromium
		echo ""
	elif [ $IB = "3" ]; then
        becho "Type Browser package-name > " ; read IBCUS
        sudo dnf install -y $IBCUS
		echo ""
    else
        echo "PASS"
		echo ""
        fi

becho "2. 🛠️ Install Fastfetch"
	sudo dnf install -y fastfetch
    cd ../../  && mkdir -p /home/$USER/.fastfetch && echo ""

becho "3. 🧑‍💻 Install VSCode from MS YUM_Repo"
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
	sudo dnf check-update && sudo dnf install -y code && echo ""

becho "4. ⌨️ Shell Customization"
	echo "Get Preset for fastfetch"
	wget https://raw.githubusercontent.com/fastfetch-cli/fastfetch/refs/heads/dev/presets/examples/13.jsonc && mv 13.jsonc /home/$USER/.fastfetch
	echo "Modify .bashrc..."
	echo "fastfetch -c /home/$USER/.fastfetch/13.jsonc" >> /home/$USER/.bashrc && echo ""
    echo ""

	becho "😎 Install ZSH...?"
	sleep 2
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
	rm -rf ./naver-whale-stable* && rm -rf ./fastfetch
	rm -f 13.jsonc && rm -f .zshrc
else
	rm -rf ./fastfetch
	rm -f 13.zshrc && rm -f .zshrc
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

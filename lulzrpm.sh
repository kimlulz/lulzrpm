#!/bin/bash
## For Fedora, Rocky, CentOS

echo "root@lulzrpm $ Change Mirror"
echo ""
## Change Mirror
	if [ -f /etc/fedora-release ]; then
		echo "Fedora Detected"
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
		echo "Rocky Linux Detected"
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
			echo "**********************************************************"
			echo "**********************************************************"
			cat /etc/yum.repos.d/Rocky-BaseOS.repo | grep navercorp
			echo "**********************************************************"
			echo "**********************************************************"
			sudo dnf install -y epel-release 

	elif [ -f /etc/centos-release ]; then
		echo "CentOS Detected"
		echo "Change mirror >>> NAVER"
		sudo sed  -i.bak -re "s/^(mirrorlist(.*))/##\1/g" -re "s/[#]*baseurl(.*)/baseurl=http:\/\/mirror.navercorp.com\/centos\/$(cat /etc/centos-release | tr -dc '0-9.'|cut -d \. -f1)\/BaseOS\/x86_64\/os/" /etc/yum.repos.d/CentOS-Linux-BaseOS.repo
		## Update
		sudo yum update
		## Check
		echo "**********************************************************"
		echo "**********************************************************"
		cat /etc/yum.repos.d/CentOS-Linux-BaseOS.repo | grep navercorp
		echo "**********************************************************"
		echo "**********************************************************"
		sudo dnf install -y epel-release 
	
	else 
	echo "Failed to Change Mirror"
	echo "Skipping..."
	fi
echo ""

echo "DNF@lulzrpm $ Update and Install Packages" 
echo ""
sudo dnf upgrade -y
sudo dnf install -y --skip-broken gnome-tweaks htop make git
if [ -f /etc/fedora-release ]; then
		echo "Fedora Detected"
		sudo dnf install -y alien
		wget https://installer-whale.pstatic.net/downloads/installers/naver-whale-stable_amd64.deb
		sudo alien -r naver-whale-stable_amd64.deb
		sudo rpm -Uvh --force naver-*.rpm

	elif [ -f /etc/rocky-release ]; then
		echo "Rocky Linux Detected"
		sudo dnf --enablerepo=powertools install alien
		wget https://installer-whale.pstatic.net/downloads/installers/naver-whale-stable_amd64.deb
		alien -r naver-whale-stable_amd64.deb
		sudo rpm -Uvh --force naver-*.rpm
	else
		echo "**********************************************************"
		echo "************************!!SKIP!!**************************"
		echo "Can't install some packages because of package dependencies"
		echo "************************!!SKIP!!**************************"
		echo "**********************************************************"
	fi
echo ""

echo "GIT@lulzrpm $ Install neofetch from Github"
echo ""
git clone https://github.com/dylanaraps/neofetch
cd neofetch
sudo make install
cd ..
echo ""

echo "DNF@lulzrpm $ Install VSCode from MS YUM_Repo"
echo ""
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update && sudo dnf upgrade
sudo dnf install -y code

echo $USERNAME"@lulzrpm $ Customize .bashrc"
echo ""
echo "PS1='\[\e[0m\][\[\e[0;1;91m\]\u\[\e[0m\]|\[\e[0;1m\]$?\[\e[0m\]] \[\e[0;1;3;4m\]\w\[\e[0m\] \[\e[0;92m\]\$ \[\e[0m\]'
neofetch" > ~/.bashrc
echo "**********************************************************"
echo "**********************************************************"
cat ~/.bashrc
echo "**********************************************************"
echo "**********************************************************"
echo "Finished"
source ~/.bashrc

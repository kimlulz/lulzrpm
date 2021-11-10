#!/bin/bash
## For Fedora, Rocky, CentOS

echo "root@lulzrpm $ Change Mirror"
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
			sed  -i.bak -re "s/^(mirrorlist(.*))/##\1/g" -re "s/[#]*baseurl(.*)/baseurl=${FULL_REPOS}/" ${BASE_REPOS} 
			## Update
			yum repolist baseos -v

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
			sed  -i.bak -re "s/^(mirrorlist(.*))/##\1/g" -re "s/[#]*baseurl(.*)/baseurl=${FULL_REPOS_PATH}/" ${R}
			done
			## Update
			yum check-update
			yum repolist baseos -v
			yum repolist appstream -v
			## Check
			echo "**********************************************************"
			echo "**********************************************************"
			echo "**********************************************************"
			cat /etc/yum.repos.d/Rocky-BaseOS.repo | grep navercorp
			echo "**********************************************************"
			echo "**********************************************************"
			echo "**********************************************************"
			sudo dnf install -y epel-release 

	elif [ -f /etc/centos-release ]; then
		echo "CentOS Detected"
		echo "Change mirror >>> NAVER"
		sed  -i.bak -re "s/^(mirrorlist(.*))/##\1/g" -re "s/[#]*baseurl(.*)/baseurl=http:\/\/mirror.navercorp.com\/centos\/$(cat /etc/centos-release | tr -dc '0-9.'|cut -d \. -f1)\/BaseOS\/x86_64\/os/" /etc/yum.repos.d/CentOS-Linux-BaseOS.repo
		yum update
		## Check
		echo "**********************************************************"
		echo "**********************************************************"
		echo "**********************************************************"
		cat /etc/yum.repos.d/CentOS-Linux-BaseOS.repo | grep navercorp
		echo "**********************************************************"
		echo "**********************************************************"
		echo "**********************************************************"
		sudo dnf install -y epel-release 
	else 
	echo "Failed to Change Mirror"
	echo "Skipping..."
	fi

echo "DNF@lulzrpm $ Update and Install Packages" 
sudo dnf update -y
sudo dnf install -y --skip-broken gnome-tweaks htop alien

echo "GIT@lulzrpm $ Install neofetch from Github"
git clone https://github.com/dylanaraps/neofetch
cd neofetch
sudo make install
cd ..

echo "RPM@lulzrpm $ Install Whale Browser(Naver) from whale.naver.com"
wget https://installer-whale.pstatic.net/downloads/installers/naver-whale-stable_amd64.deb
sudo alien -r naver-whale-stable_amd64.deb
sudo rpm -Uvh --force naver-*.rpm

echo "DNF@lulzrpm $ Install VSCode from MS YUM_Repo"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install -y code

echo $USERNAME"@lulzrpm $ Customize .bashrc"
echo "PS1='\[\e[0m\][\[\e[0;1;91m\]\u\[\e[0m\]|\[\e[0;1m\]$?\[\e[0m\]] \[\e[0;1;3;4m\]\w\[\e[0m\] \[\e[0;92m\]\$ \[\e[0m\]'
neofetch" > ~/.bashrc
cat ~/.bashrc
echo "Finished"
bash

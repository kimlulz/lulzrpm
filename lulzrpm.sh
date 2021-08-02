#!/bin/bash
## For Fedora, Rocky, CentOS

## Change Mirror
if [ -f /etc/fedora-release ]; then
	echo "Fedora Confirmed"
	echo "Change mirror > KAIST_fedora"
    wget https://gist.githubusercontent.com/kimlulz/e8c9d0c9e2577d4d34819292d233985b/raw/d55ba1d631d3b04a0d5b8554cab354f15d5d2ccc/change-fedora-mirror.sh
    sudo sh change-fedora-mirror.sh

elif [ -f /etc/rocky-release ]; then
	echo "Rocky Linux Confirmed"
	echo "Change mirror > NaverCloud_Rocky"
	wget https://gist.githubusercontent.com/kimlulz/742b304736d48a569bcc9be71113c294/raw/6c964cf843d05883f8f4eb438af33fa59a04f84d/change-rocklinux-mirror.sh
	sudo sh change-rocklinux-mirror.sh
	
elif [ -f /etc/centos-release ]; then
	echo "CentOS Confirmed"
	echo "Change mirror > KAKAO_CentOS"
    wget https://gist.githubusercontent.com/kimlulz/f8b98bf6d2ee21332ee4d183030f55a2/raw/7c503726b5c234beb576d7c85a3a683cc1cc2999/change-centos-mirror.sh
    sudo sh change-centos-mirror.sh -k
else 
echo "Failed to Change Mirror"
fi

## Update and Install Packages 
sudo dnf update -y
sudo dnf install -y gnome-tweaks htop alien

## Install neofetch from Github
git clone https://github.com/dylanaraps/neofetch
cd neofetch
sudo make install
cd ..

## Install Naver Whale Browser from whale.naver.com
wget https://installer-whale.pstatic.net/downloads/installers/naver-whale-stable_amd64.deb
sudo alien -r naver-whale-stable_amd64.deb
sudo rpm -Uvh --force naver-*.rpm

## Install VSCode from MS YUM_Repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install -y code

## Customize .bashrc
echo "PS1='\[\e[0m\][\[\e[0;1;91m\]\u\[\e[0m\]|\[\e[0;1m\]$?\[\e[0m\]] \[\e[0;1;3;4m\]\w\[\e[0m\] \[\e[0;92m\]\$ \[\e[0m\]'
neofetch" > ~/.bashrc 
cat ~/.bashrc
echo "Finished"
source ~/.bashrc


#!/bin/bash
#INIT 
b=$(tput bold)	#굵게
n=$(tput sgr0)	#일반글씨
rockyrepo=https://download.rockylinux.org/pub/rocky/10/BaseOS/x86_64/os/Packages/r

echo "${b}0. Initialization"
	if [ -f /etc/rocky-release ]; then
		echo "Rocky Linux Detected.."
		sleep 5
	elif [ -f /etc/centos-release ]; then
		echo "It seems you are using CentOS $(cat /etc/centos-release | sed 's/[^0-9,.]//g')"
		echo "${b}Convert to Rocky? [y, n]${n}"
		echo -n "${b}> ${n}" ;read covrl
		if [ $covrl = "y" -o $covrl = "Y" ]; then
			wget https://raw.githubusercontent.com/rocky-linux/rocky-tools/main/migrate2rocky/migrate2rocky.sh
			chmod +x migrate2rocky.sh
			sudo ./migrate2rocky.sh -r -V
		else 
			echo "Stop processing script..."
			exit
		fi
	else
		echo "It seems you are using unsupported distro."
		echo "Exit..." 
		exit
	fi

echo "${b}1. Change Repos to el10"
	echo "${b}Download packages...${n}"
		wget -r -l1 --no-parent -A "rocky*" $rockyrepo
		mv ./download.rockylinux.org/pub/rocky/10/BaseOS/x86_64/os/Packages/r/* ./
		rm -rf ./download.rockylinux.org 
	echo "${b}Install..."
		sudo dnf -y install ./rocky-{gpg-keys,release,repos}-10.*.rpm
	echo "${b}Remove conflict repos and packages"
		sudo dnf -y remove rpmconf yum-utils epel-release
		rm -rf /usr/share/redhat-logos
	echo "${b}Distro-Sync"
		sudo dnf -y --releasever=10 --allowerasing --setopt=deltarpm=false distro-sync

echo "${b}2. Remove older kernels and resolve dependencies"
	echo "${b}Remove order kernels..."
		cd /var/lib/rpm 
		rm -f __db.00*
		rpm --rebuilddb
	echo "${b}Update"
		dnf update -y
	echo "${b}Need reboot. Reboot now? [y / n or any key]${n}"
		echo -n "${b}> ${n}" ;read yn
		if [ $yn = "y" -o $yn = "Y" ]; then
			reboot
		else 
			echo "Finished!"
			echo "Need to reboot manually"
			exit
		fi

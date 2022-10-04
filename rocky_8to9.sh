#!/bin/bash
#INIT 
b=$(tput bold)	#굵게
n=$(tput sgr0)	#일반글씨
rockyrepo=https://download.rockylinux.org/pub/rocky/9/BaseOS/x86_64/os/Packages/r

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

echo "${b}1. Change Repos to el9"
	echo "${b}Download packages...${n}"
		wget -r -l1 --no-parent -A "rocky*" $rockyrepo
		mv ./download.rockylinux.org/pub/rocky/9/BaseOS/x86_64/os/Packages/r/* ./
		rm -rf ./download.rockylinux.org 
	echo "${b}Install..."
		sudo dnf -y install ./rocky-{gpg,release,repos}-9.*.rpm
	echo "${b}Remove conflict packages"
		sudo dnf -y remove rpmconf yum-utils epel-release
		rm -rf /usr/share/redhat-logos
	echo "${b}Distro-Sync"
		sudo dnf -y --releasever=9 --allowerasing --setopt=deltarpm=false distro-sync

echo "${b}2. Remove older kernels and resolve dependencies"
	echo "${b}Remove order kernels..."
		cd /var/lib/rpm 
		rm -f __db.00*
		rpm --rebuilddb
		rpm -e --nodeps  `rpm -qa|grep -i kernel|grep 4.18`
	echo "${b}Resolve dependencies..."
		dnf module disable perl container-tools llvm-toolset virt perl-IO-Socket-SSL perl-libwww-perl python36 perl-DBI perl-DBD-SQLite
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
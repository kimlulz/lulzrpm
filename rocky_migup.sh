#!/bin/bash
BL=$(tput bold)
NRM=$(tput sgr0)

function becho {
	>&2 echo -n "$BL$1$NRM"
    echo ""
}

fkredhat(){
	if [ -f /etc/rocky-release ]; then
		echo "Rocky Linux Detected.."
		sleep 5
	elif [ -f /etc/centos-release ]; then
		echo "It seems you are using CentOS $(cat /etc/centos-release | sed 's/[^0-9,.]//g')"
		echo "Convert to Rocky? [y, n]"
		echo -n "> " ;read covrk
		if [ $covrk = "y" -o $covrk = "Y" ]; then
			wget https://raw.githubusercontent.com/rocky-linux/rocky-tools/main/migrate2rocky/migrate2rocky.sh && chmod +x migrate2rocky.sh
            sudo ./migrate2rocky.sh -r -V
            exit
		else 
			echo "Stop processing script..."
			exit
		fi
	else
		echo "It seems you are using unsupported distro."
		echo "Exit..." 
		exit
	fi
}

levelup(){
    rocky_version=$(cat /etc/rocky-release)
    if [[ "$rocky_version" =~ 8 ]]; then
        becho "Rocky Linux 8 Detected"
        eightnine
    elif [[ "$rocky_version" =~ 9 ]]; then
        becho "Rocky Linux 9 Detected"
        nineten
    elif [[ "$rocky_version" =~ 10 ]]; then
        becho "Rocky Linux 10 Detected"
        becho "There is nothing you can do with this version yet."
        becho "Cuz It's already the latest version"
        becho "Exit..." && sleep 3 && exit
    else
        echo "It seems you are using an unsupported distro."
        echo "Exit..."
        exit
    fi
}

eightnine(){
    ninerepo=https://download.rockylinux.org/pub/rocky/9/BaseOS/x86_64/os/Packages/r
    echo "1. Change Repos to el9"
	echo ""
		wget -r -l1 --no-parent -A "rocky*" $ninerepo
		mv ./download.rockylinux.org/pub/rocky/9/BaseOS/x86_64/os/Packages/r/* ./
		rm -rf ./download.rockylinux.org 
	echo "Install..."
		sudo dnf -y install ./rocky-{gpg-keys,release,repos}-9.*.rpm
	echo "Remove Third-Party Repository"
		sudo dnf -y remove rpmconf yum-utils epel-release
		rm -rf /usr/share/redhat-logos
	echo " "
		sudo dnf -y --releasever=9 --allowerasing --setopt=deltarpm=false distro-sync
}

becho "💿🔍 Checking Distro.."
fkredhat

becho "🎚️🔍 Checking Version.."
levelup
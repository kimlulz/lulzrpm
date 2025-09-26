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
    rocky_version=$(grep -oP '\d+' /etc/rocky-release | head -1)
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
        becho "It seems you are using an unsupported distro."
        becho "Exit..."
        exit
    fi
}

eightnine(){
    ninerepo=https://download.rockylinux.org/pub/rocky/9/BaseOS/x86_64/os/Packages/r
    echo -e "\033[31m"Upgrade Rocky Linux 8 to 9"\033[0m"
    becho "1. 🛠️ Change Repos to el9"
	echo ""
		wget -r -l1 --no-parent -A "rocky*" $ninerepo
		mv ./download.rockylinux.org/pub/rocky/9/BaseOS/x86_64/os/Packages/r/* ./
		rm -rf ./download.rockylinux.org 
	becho "🛠️ Install..."
		sudo dnf -y install ./rocky-{gpg-keys,release,repos}-9.*.rpm
	becho "🗑️ Remove Third-Party Repository"
		sudo dnf -y remove rpmconf yum-utils epel-release
		rm -rf /usr/share/redhat-logos
	echo ""
		sudo dnf -y --releasever=9 --allowerasing --setopt=deltarpm=false distro-sync && echo ""

    becho "2. 🗑️ Remove older kernels and resolve dependencies"
	echo "🗑️ Remove order kernels..."
		cd /var/lib/rpm 
		rm -f __db.00*
		rpm --rebuilddb
		rpm -e --nodeps  `rpm -qa|grep -i kernel|grep 4.18`
	echo "🛠️ Resolve dependencies..."
		dnf module disable -y perl container-tools llvm-toolset virt perl-IO-Socket-SSL perl-libwww-perl python36 perl-DBI perl-DBD-SQLite
	echo "⬆️ Update"
		dnf update -y
}

nineten(){
    tenrepo=https://download.rockylinux.org/pub/rocky/10/BaseOS/x86_64/os/Packages/r
    echo -e "\033[31m"Upgrade Rocky Linux 9 to 10"\033[0m"
    becho "1. 🛠️ Change Repos to el10"
	echo ""
		wget -r -l1 --no-parent -A "rocky*" $tenrepo
		mv ./download.rockylinux.org/pub/rocky/10/BaseOS/x86_64/os/Packages/r/* ./
		rm -rf ./download.rockylinux.org 
	becho "🛠️ Install..."
		sudo dnf -y install ./rocky-{gpg-keys,release,repos}-10.*.rpm
		sudo dnf clean all && sudo dnf repolist
		sudo sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/rocky.repo
		echo "[baseos] 
name=Rocky Linux 10 - BaseOS 
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=BaseOS-10 
enabled=1 
gpgcheck=0 " >> /etc/yum.repos.d/rocky.repo
		sudo sed -i s/RPM-GPG-KEY-Rocky-9/RPM-GPG-KEY-Rocky-10/g /etc/yum.repos.d/rocky.repo
	becho "🗑️ Remove Third-Party Repository"
		sudo dnf -y remove rpmconf yum-utils epel-release
		sudo rm -rf /usr/share/redhat-logos
	echo "🔄️ Sync"
		sudo dnf repolist -v
		sudo dnf -y --releasever=10 --allowerasing --setopt=deltarpm=false distro-sync && echo ""

    becho "2. 🗑️ Remove older kernels and resolve dependencies"
	echo "🗑️ Remove order kernels..."
		cd /var/lib/rpm 
		sudo rm -f __db.00*
		sudo rpm --rebuilddb
        rpm -e $(rpm -qa | grep .el9.)
	echo "Update"
		sudo dnf update -y
}

fini(){
    sleep 3
    echo "🔄️ Need reboot. Reboot now? [y / n or any key]"
		echo -n "> " ;read yn
		if [ $yn = "y" -o $yn = "Y" ]; then
            becho "Rebooting..." && sleep 5
			reboot
		else 
			becho "🎉 Finished! 🎉"
			becho "⚠️ Need to reboot manually ⚠️" && sleep 3
			exit
		fi
}


becho "💿🔍 Checking Distro.."
fkredhat

becho "🎚️🔍 Checking Version.."
levelup

becho "🥳 Finished..."
fini

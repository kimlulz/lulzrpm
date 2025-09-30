#!/bin/bash
BL=$(tput bold)
NRM=$(tput sgr0)

function becho {
	>&2 echo -n "$BL$1$NRM"
    echo ""
}

gogogo(){
	clear && becho "Before start, Make sure your system packages are Up-to-date (With booted to newer kernel)!! (ctrl+c to cancel) ." && sleep 1
	clear && becho "Before start, Make sure your system packages are Up-to-date (With booted to newer kernel)!! (ctrl+c to cancel) .." && sleep 1
	clear && becho "Before start, Make sure your system packages are Up-to-date (With booted to newer kernel)!! (ctrl+c to cancel) ..." && sleep 1
	clear && becho "Before start, Make sure your system packages are Up-to-date (With booted to newer kernel)!! (ctrl+c to cancel) ...." && sleep 1
	clear && becho "Before start, Make sure your system packages are Up-to-date (With booted to newer kernel)!! (ctrl+c to cancel) ....." && sleep 1
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
		sleep 5
        eightnine
    elif [[ "$rocky_version" =~ 9 ]]; then
        becho "Rocky Linux 9 Detected"
		sleep 5
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

initup(){
	sudo dnf autoremove -y
	sudo dnf clean all
}

eightnine(){
	clear
    ninerepo=https://download.rockylinux.org/pub/rocky/9/BaseOS/x86_64/os/Packages/r
    echo -e "\033[31m"Upgrade Rocky Linux 8 to 9"\033[0m"
    becho "1. 🛠️ Change Repos to el9"
	echo ""
		wget -r -l1 --no-parent -A "rocky*" $ninerepo
		mv ./download.rockylinux.org/pub/rocky/9/BaseOS/x86_64/os/Packages/r/* ./
		rm -rf ./download.rockylinux.org 
		clear
	becho "🛠️ Install..."
		sudo dnf -y install ./rocky-{gpg-keys,release,repos}-9.*.rpm
		clear
	becho "🗑️ Remove Third-Party Repository"
		sudo dnf -y remove rpmconf yum-utils epel-release
		rm -rf /usr/share/redhat-logos
		clear
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
	clear
    echo -e "\033[31m"Upgrade Rocky Linux 9 to 10"\033[0m"
    becho "1. 🛠️ Download Prerequired Packages..."
	echo ""
		wget -r -l1 --no-parent -A "rocky*" $tenrepo
		mv ./download.rockylinux.org/pub/rocky/10/BaseOS/x86_64/os/Packages/r/* ./
		rm -rf ./download.rockylinux.org 
		sleep 3 && clear
	becho "🛠️ Install Prerequired Packages..."
		#sudo cp -r /etc/yum.repos.d /etc/yum.repos.d.bak && sudo sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/*.repo
		sudo sed -i 's|$releasever - BaseOS|10 - BaseOS|g' /etc/yum.repos.d/rocky.repo 
		sudo sed -i 's|BaseOS-$releasever|BaseOS-10|g' /etc/yum.repos.d/rocky.repo 
		cat /etc/yum.repos.d/rocky.repo && sleep 5
		sudo dnf -y install ./rocky-{gpg-keys,release,repos}-10.*.rpm
		sudo sed -i s/RPM-GPG-KEY-Rocky-9/RPM-GPG-KEY-Rocky-10/g /etc/yum.repos.d/rocky.repo
		sudo dnf clean all && sudo dnf repolist
		sleep 3 && clear
	becho "🗑️ Remove Third-Party Repository"
		sudo dnf -y remove rpmconf yum-utils epel-release
		sudo rm -rf /usr/share/redhat-logos
		sleep 3 && clear
	echo "🔄️ Sync"
		sudo dnf repolist -v
		sudo dnf update -y --allowerasing
		sudo dnf -y --releasever=10 --allowerasing --setopt=deltarpm=false distro-sync && echo ""
		sleep 3 && clear

    becho "2. 🗑️ Remove older kernels and resolve dependencies"
		sudo dnf -y autoremove
		sudo dnf -y distro-sync
	#echo "🗑️ Remove order kernels..."
		#cd /var/lib/rpm 
		#sudo rm -f __db.00*
		#sudo rpm --rebuilddb
        #sudo rpm -e $(rpm -qa | grep .el9.) && sleep 3
}

fini(){
    sleep 3 && clear
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

gogogo

becho "💿🔍 Checking Distro.."
sleep 3

becho "💿🔍 Checking Distro.."
fkredhat

becho "⬆️ Update all Packages.."
initup

becho "🎚️🔍 Checking Version.."
levelup

becho "🥳 Finished..."
fini

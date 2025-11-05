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
	if [ -f /etc/almalinux-release ]; then
		echo "AlmaLinux Detected.."
		sleep 5
	elif [ -f /etc/centos-release ]; then
		echo "It seems you are using CentOS $(cat /etc/centos-release | sed 's/[^0-9,.]//g')"
		echo "Convert to AlmaLinux? [y, n]"
		echo -n "> " ;read coval
		if [ $coval = "y" -o $coval = "Y" ]; then
			curl -O https://raw.githubusercontent.com/AlmaLinux/almalinux-deploy/master/almalinux-deploy.sh
            sudo bash almalinux-deploy.sh
            sudo reboot
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
    alma_version=$(grep -oP '\d+' /etc/almalinux-release | head -1)
    if [[ "$alma_version" =~ 8 ]]; then
        becho "AlmaLinux 8 Detected"
		sleep 5
        eightnine
    elif [[ "$alma_version" =~ 9 ]]; then
        becho "AlmaLinux 9 Detected"
		sleep 5
        nineten
    elif [[ "$alma_version" =~ 10 ]]; then
        becho "AlmaLinux 10 Detected"
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
    ninerepo=https://repo.almalinux.org/almalinux/9/BaseOS/x86_64/os/Packages
    echo -e "\033[31m"Upgrade AlmaLinux 8 to 9"\033[0m"
    becho "1. 🛠️ Change Repos to el9"
	echo ""
		wget -r -l1 --no-parent -A "almalinux*" $ninerepo
		mkdir ./tmp
		mv ./repo.almalinux.org/almalinux/9/BaseOS/x86_64/os/Packages/* ./tmp
		rm -rf ./repo.almalinux.org
		clear && sleep 3
	becho "🛠️ Install..."
		sudo dnf -y install ./tmp/almalinux-{gpg-keys,release,repos}-9.*.rpm
		clear && sleep 3
	becho "🗑️ Remove Third-Party Repository"
		sudo dnf -y remove rpmconf yum-utils epel-release elrepo-release
		rm -rf /usr/share/redhat-logos
		clear && sleep 3
	echo ""
		sudo dnf repolist -v
		sudo dnf update -y --allowerasing
		sudo dnf -y --releasever=9 --allowerasing --setopt=deltarpm=false distro-sync && echo "" && sleep 3

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
    tenrepo=https://repo.almalinux.org/almalinux/10/BaseOS/x86_64/os/Packages
	clear
    echo -e "\033[31m"Upgrade AlmaLinux 9 to 10"\033[0m"
    becho "1. 🛠️ Download Prerequired Packages..."
	echo ""
		wget -r -l1 --no-parent -A "almalinux*" $tenrepo
		mkdir ./tmp
		mv ./repo.almalinux.org/almalinux/10/BaseOS/x86_64/os/Packages/* ./tmp
		rm -rf ./repo.almalinux.org
		sleep 3 && clear
	becho "🛠️ Install Prerequired Packages..."
		#sudo cp -r /etc/yum.repos.d /etc/yum.repos.d.bak && sudo sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/*.repo
		sudo sed -i 's|$releasever|10|g' /etc/yum.repos.d/almalinux.repo 
		cat /etc/yum.repos.d/alma.repo && sleep 5
		sudo dnf -y install ./tmp/almalinux-{gpg-keys,release,repos}-10.*.rpm
		sudo sed -i s/RPM-GPG-KEY-AlmaLinux-9/RPM-GPG-KEY-AlmaLinux-10/g /etc/yum.repos.d/almalinux.repo
		sudo dnf clean all && sudo dnf repolist
		sleep 3 && clear
	becho "🗑️ Remove Third-Party Repository"
		sudo dnf -y remove rpmconf yum-utils epel-release
		sudo rm -rf /usr/share/redhat-logos
		sleep 3 && clear
	echo "🔄️ Sync"
		sudo dnf repolist -v
		# will remove command below(one of the two below)
		sudo dnf update -y --allowerasing
		sudo dnf -y --releasever=10 --allowerasing --setopt=deltarpm=false distro-sync && echo ""
		sleep 3 && clear

    becho "2. 🗑️ Remove older kernels and resolve dependencies"
		sudo dnf -y autoremove && sudo dnf -y distro-sync
		sudo rm -rf ./tmp
		sudo sed -i 's|/10|/$releasever|g' /etc/yum.repos.d/alma.repo 
		sudo dnf -y install sqlite almalinux-backgrounds gnome-extensions-app gnome-text-editor
		sudo dnf -y remove kernel-5* kernel-core-5* kernel-devel-5* kernel-header-5*
		sudo rpm --rebuilddb
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

sleep 3
becho "💿🔍 Checking Distro.."
fkredhat

becho "⬆️ Update all Packages.."
initup

becho "🎚️🔍 Checking Version.."
levelup

becho "🥳 Finished..."
fini

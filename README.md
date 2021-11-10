# lulzrpm
Script for configure my desktop environment | Fedora, Centos, Rocky   
`sh [script].sh` to execute script.

## **lulzrpm.sh**
### Change **mirror**
```
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
```

### **[DNF]** Update and Install Packages
`sudo dnf update -y`   
`sudo dnf install -y gnome-tweaks htop alien make`   

#### **[RPM]** Install Whale Browser(Naver) from whale.naver.com | FEDORA ONLY
Install package(DEB) from whale.naver.com   
It will only be installed in fedora..   
`sudo alien -r naver-whale-stable_amd64.deb` Convert DEB to RPM    
`sudo rpm -Uvh --force naver-*.rpm` Install RPM Locally

### **[GIT]** Install Neofetch from Github
cuz official repo has old packages.   

### **[DNF]** Install VSCODE from MS REPO
Refer to `https://code.visualstudio.com/docs/setup/linux`    

### Customize *~/.bashrc*
![스크린샷, 2021-08-02 16-01-27](https://user-images.githubusercontent.com/42508318/127818048-d229e0d1-b36c-4eb1-bc64-30028421384b.png)    
`PS1='\[\e[0m\][\[\e[0;1;91m\]\u\[\e[0m\]|\[\e[0;1m\]$?\[\e[0m\]] \[\e[0;1;3;4m\]\w\[\e[0m\] \[\e[0;92m\]\$ \[\e[0m\]`    

## **d2d_gnome40.sh**
Install Dash-to-Dock for GNOME 40
Ported by ewlsh (https://github.com/ewlsh/dash-to-dock/tree/ewlsh/gnome-40)
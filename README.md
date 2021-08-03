# lulzrpm
Script for configure my desktop environment | Fedora, Centos, Rocky   
`sh [script].sh` to execute script.

## lulzrpm.sh
### Change mirror
```
if [ -f /etc/fedora-release ]; then
	echo "Fedora Detected"
	echo "Change mirror >>> KAIST_fedora"
    wget https://gist.githubusercontent.com/kimlulz/e8c9d0c9e2577d4d34819292d233985b/raw/d55ba1d631d3b04a0d5b8554cab354f15d5d2ccc/change-fedora-mirror.sh
    sudo sh change-fedora-mirror.sh

elif [ -f /etc/rocky-release ]; then
	echo "Rocky Linux Detected"
	echo "Change mirror >>> NaverCloud_Rocky"
	wget https://gist.githubusercontent.com/kimlulz/742b304736d48a569bcc9be71113c294/raw/6c964cf843d05883f8f4eb438af33fa59a04f84d/change-rocklinux-mirror.sh
	sudo sh change-rocklinux-mirror.sh
	
elif [ -f /etc/centos-release ]; then
	echo "CentOS Detected"
	echo "Change mirror >>> KAKAO_CentOS"
    wget https://gist.githubusercontent.com/kimlulz/f8b98bf6d2ee21332ee4d183030f55a2/raw/7c503726b5c234beb576d7c85a3a683cc1cc2999/change-centos-mirror.sh
    sudo sh change-centos-mirror.sh -k
else 
echo "Failed to Change Mirror"
fi
```

### [DNF] Update and Install Packages
`sudo dnf update -y`   
`sudo dnf install -y gnome-tweaks htop alien`   

### [GIT] Install Neofetch from Github
cuz official repo has old packages.   

### [RPM] Install Whale Browser(Naver) from whale.naver.com
Install package(DEB) from whale.naver.com   
`sudo alien -r naver-whale-stable_amd64.deb` Convert DEB to RPM    
`sudo rpm -Uvh --force naver-*.rpm` Install RPM Locally

### [DNF] Install VSCODE from MS REPO
Refer to `https://code.visualstudio.com/docs/setup/linux`    

### Customize ~/.bashrc
![스크린샷, 2021-08-02 16-01-27](https://user-images.githubusercontent.com/42508318/127818048-d229e0d1-b36c-4eb1-bc64-30028421384b.png)    
`PS1='\[\e[0m\][\[\e[0;1;91m\]\u\[\e[0m\]|\[\e[0;1m\]$?\[\e[0m\]] \[\e[0;1;3;4m\]\w\[\e[0m\] \[\e[0;92m\]\$ \[\e[0m\]`    

## d2d_gnome40.sh
Install Dash-to-Dock for GNOME 40
Ported by ewlsh (https://github.com/ewlsh/dash-to-dock/tree/ewlsh/gnome-40)
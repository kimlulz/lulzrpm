# lulzrpm
Script for configure my desktop environment | Fedora, EL-Based(Rocky)

`sh [script].sh` to execute script.

## **lulzrpm.sh**
**CentOS is no longer supported!!**

**Migrate to Rocky through [officially provided scripts](https://raw.githubusercontent.com/rocky-linux/rocky-tools/main/migrate2rocky/migrate2rocky.sh)**
### Change **mirror**
```
FEDORA = KAIST https://ftp.kaist.ac.kr/fedora/
ROCKY = NAVER https://mirror.navercorp.com/rocky/
CentOS = NAVER https://mirror.navercorp.com/centos/
```

### **[DNF]** Update and Install Packages
`sudo dnf update -y`   
`sudo dnf install -y gnome-tweaks htop make`   

#### **[RPM]** Install Whale Browser(Naver) from whale.naver.com
Fedora, Rocky  
```
sudo dnf install alien (Rocky Linux use powertools repo)
Install package(DEB) from whale.naver.com   
`sudo alien -r naver-whale-stable_amd64.deb` Convert DEB to RPM    
`sudo rpm -Uvh --force naver-*.rpm` Install RPM Locally
```
CentOS won't install browser.    

### **[GIT]** Install Neofetch from Github
cuz official repo has old packages.   

### **[DNF]** Install VSCODE from MS REPO
Refer to `https://code.visualstudio.com/docs/setup/linux`    

### Customize *~/.bashrc*
![스크린샷, 2021-08-02 16-01-27](https://user-images.githubusercontent.com/42508318/127818048-d229e0d1-b36c-4eb1-bc64-30028421384b.png)    
`PS1='\[\e[0m\][\[\e[0;1;91m\]\u\[\e[0m\]|\[\e[0;1m\]$?\[\e[0m\]] \[\e[0;1;3;4m\]\w\[\e[0m\] \[\e[0;92m\]\$ \[\e[0m\]`    



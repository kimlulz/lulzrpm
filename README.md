# lulzrpm
Script for configure desktop environment | Fedora, EL-based(Rocky, Alma)

## **lulzrpm.sh**
**CentOS is no longer supported!!**

**Migrate to Rocky through [officially provided scripts](https://raw.githubusercontent.com/rocky-linux/rocky-tools/main/migrate2rocky/migrate2rocky.sh)**
### **Change mirror**
```
FEDORA = KAIST https://ftp.kaist.ac.kr/fedora/
ROCKY = NAVER https://mirror.navercorp.com/rocky/
```

### **Update and Install Packages**
install `gnome-tweaks htop make cmake git`

#### **Install Browser**
| Name | Method | From |
| :- | :- | :- |
| **Naver Whale**  | DNF-(Alien)-RPM | Using deb image |
| **Chromium**  | DNF | From repository |
| **🔥FireFox🦊*  | DNF | Included |

### **Build fastfetch**
>Fastfetch is a neofetch-like tool for fetching system information and displaying it in a visually appealing way. It is written mainly in C, with a focus on performance and customizability. Currently, it supports Linux, macOS, Windows 7+, Android, FreeBSD, OpenBSD, NetBSD, DragonFly, Haiku, and SunOS.

refer _[fastfetch](https://github.com/fastfetch-cli/fastfetch)_

### **Install VSCODE**

### **Install ZSH and Customize**
Install ZSH and ZPlug
```
# .zshrc (use zplug)

source ~/.zplug/init.zsh

# Plugins
zplug "plugins/git",   from:oh-my-zsh
zplug "lib/completion",   from:oh-my-zsh
zplug 'lib/key-bindings', from:oh-my-zsh
zplug "lib/directories",  from:oh-my-zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"

zplug 'romkatv/powerlevel10k', as:theme, depth:1

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load
```
<img width="708" height="461" alt="스크린샷, 2025-09-26 12-58-52" src="https://github.com/user-attachments/assets/206652b3-4aff-40e3-bbf5-9bd2ef13d3c2" />


### **Customize `~/.bashrc`**
`PS1='\[\e[0m\][\[\e[0;1;91m\]\u\[\e[0m\]|\[\e[0;1m\]$?\[\e[0m\]] \[\e[0;1;3;4m\]\w\[\e[0m\] \[\e[0;92m\]\$ \[\e[0m\]`    
<img width="708" height="441" alt="스크린샷, 2025-09-26 13-00-09" src="https://github.com/user-attachments/assets/f1063bef-14aa-482f-8c2d-13a9076fd326" />

## **rocky_migup.sh**
Upgrade Rocky Linux 8 -> 9, 9 -> 10
```
⚠️ DO AT YOUR OWN RISK!!!
```
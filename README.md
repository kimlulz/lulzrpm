# lulzrpm
Script for configure desktop environment | Fedora, EL-Based(Rocky)

## **lulzrpm.sh**
**CentOS is no longer supported!!**

**Migrate to Rocky through [officially provided scripts](https://raw.githubusercontent.com/rocky-linux/rocky-tools/main/migrate2rocky/migrate2rocky.sh)**
### Change **mirror**
```
FEDORA = KAIST https://ftp.kaist.ac.kr/fedora/
ROCKY = NAVER https://mirror.navercorp.com/rocky/
```

### **[DNF]** Update and Install Packages
install `gnome-tweaks htop make cmake git`

#### **[RPM]** Install Browser
| Name | Method | From |
| :- | :- | :- |
| **[Fedora Only]Naver Whale**  | Package? | Using deb image |
| **Chromium**  | DNF | From repository |
Or just use 🔥FireFox🦊

### **[GIT]** Build fastfetch
>Fastfetch is a neofetch-like tool for fetching system information and displaying it in a visually appealing way. It is written mainly in C, with a focus on performance and customizability. Currently, it supports Linux, macOS, Windows 7+, Android, FreeBSD, OpenBSD, NetBSD, DragonFly, Haiku, and SunOS.

refer _[fastfetch](https://github.com/fastfetch-cli/fastfetch)_

### **[DNF]** Install VSCODE

### Customize *~/.bashrc*
![스크린샷, 2021-08-02 16-01-27](https://user-images.githubusercontent.com/42508318/127818048-d229e0d1-b36c-4eb1-bc64-30028421384b.png)    
`PS1='\[\e[0m\][\[\e[0;1;91m\]\u\[\e[0m\]|\[\e[0;1m\]$?\[\e[0m\]] \[\e[0;1;3;4m\]\w\[\e[0m\] \[\e[0;92m\]\$ \[\e[0m\]`    



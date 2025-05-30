![alt text](https://cdn.wccftech.com/wp-content/uploads/2015/09/First_Assault_group_shot_1442394288.png)


# Project Name

sysadmin-stuff - UNDER CONSTRUCTION !

### FOR UBUNTU 16.04 LTS or later

#### Now Devops oriented tools bootstrapping
I have added now a different, segragated section for devops, with its own utils and cfg so you can toggle utils on/off (keep reading the README.md)
It has its own devops/ directory, and works as the pentest one (see underneath). You can avoid installing the devops tools by setting, in the devops/devops.cfg entry to 0: enable_devops_utils=0, insted of =1 (default)

## Installation
You ought to use sudo atm to do the installation.
To install first clone the project as non root. **you would be prompted few times, one for git and one for Mariadb (if toggled on)**.
It is also crucial that you have git installed, and cofigured with your email and user already; do it when I prompt you (more likely as you may wish to run this script in a freshly installed Ubuntu).

The cfg file where you toggle tools on/off for sysadmin stuff, is sysadmin.cfg file. So make sure you toggle the 
tools in sysadmin.cfg as you like (on/off/) So in order to run the script, run: 
```bash
$ git clone https://github.com/toxeek/sysadmin-stuff.git
$ cd sysadmin-stuff
$ sudo ./install.sh
```
## Dependencies
You will need git installed and ready to clone the repository, and a GNU/Linux system Ubuntu 16.04 at least per using snap for certain packages such as docker and VSCode.

## Usage
When you first clone it, cd into the sysadmin-stuff folder. There you will see a sysadminf.cfg file with a key=value format for the sys utils that's to be installed (or not). if the value equals 1, then it will be installed. To disable that installation of certain util, in the cfg file make the value  set to =0 instead. In the case of Terraform (in the devops folder, devops.cfg file), single quote the version you want installed, make sure you toggle tfevn=1 tho .. as we use tfenv to install and manage terraform version/s we want installed.

There are other .cfg files, to install non sys/devops/pentest related tools, but it's all explained bellow.

***
#### sysadmin.cfg and other *.cfg files is where you toggle utils on/off
***
#### Added the pentest folder, so as with other utils, there is an utils.sh and pentest.cfg following the same structure as other utils, always look and setup.sh

#### [~] pentest directory:
```bash
$ pwd
/home/tricky/code/git/sysadmin-stuff/pentest
$ ls -ltr
total 12
drwxrwxr-x 2 tricky tricky 4096 Jun 12 23:37 nmap-nse
-rw-rw-r-- 1 tricky tricky   77 Jun 13 18:27 pentest.cfg
-rw-rw-r-- 1 tricky tricky 1945 Jun 13 18:56 utils.sh
```

#### Also for nmap nse scripts, there is a subfolder into nmap-nse folder, for nse based nmap scripts installation, also following the structure of our utils within other parent directories:
```bash
$ pwd
/home/tricky/code/git/sysadmin-stuff
$ ls
LICENSE  README.md  chk_root.sh  helpers.sh  install.sh  pentest  setup.sh  sysadmin.cfg  utils.sh
$ cd pentest/
$ ls
nmap-nse  pentest.cfg  utils.sh
$ cd nmap-nse/
$ ls
nse.cfg  utils.sh
```
#### [~] you can enable installing the following pentest tools: ***(see pentest.cfg)***
![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "pentest tools")
1. ***nmap***
2. ***sqlmap***
4. ***sipvicious***
5. ***hydra***
6. ***wpscan***
___

#### [~] you can enable these nse nmap scripts: ***(see nse.cfg)***
![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "nse scripts")
1. ***http-headers***
2. ***http-enum***
3. ***dns-brute***
4. ***vulscan***
___

**For the pentest tools installation, I provide a parameter named** *enable_pentest_utils* **that you can use to toggle off/on the installation of the pentest tools**
```bash
$ pwd
/home/tricky/code/git/sysadmin-stuff/pentest
$ cat pentest.cfg
## pentest utils
enable_pentest_utils=1
sqlmap=1
nmap=1
sipvicious=1
```
#### added sipvicious for VOIP pentest research .. Remember sipvicious installs many tools:
```bash 
$ sipvicious_svcrack   sipvicious_svcrash   sipvicious_svmap     sipvicious_svreport  sipvicious_svwar
```
##### so to get help with say, sipvicious_svcrack, do:
```bash
# sipvicious_svcrack --help
```
#### sipvicious github: https://github.com/EnableSecurity/sipvicious/blob/master/README.md
___
```bash
$ pwd
/home/tricky/code/git/sysadmin-stuff/pentest
$ cat pentest.cfg
## pentest utils
enable_pentest_utils=1
sqlmap=1
nmap=1
tricky@trickylocalhost:~/code/git/sysadmin-stuff/pentest$ ls
nmap-nse  pentest.cfg  utils.sh
$ cd nmap-nse/
$ pwd
/code/git/sysadmin-stuff/pentest/nmap-se
$ ls
nse.cfg  utils.sh
$ cat nse.cfg
## nmap nse scripts cfg
http-headers=1
http-enum=1
```
___
#### ***if you choose to install mariadb 10.5 (in sysadmin.cfg utils file) I do a mysql_secure_installation so you will be prompted for decisions. If you already installed mariadb, with my scripts, we detect it and skip re-running mysql_secure_installation. I try to make it idempotent, so you can re-run the script without hassle multiple times***
___

## Contributing

https://kbroman.org/github_tutorial/pages/fork.html#:~:text=Go%20to%20your%20version%20of%20the%20repository%20on%20github.,button%20%E2%80%9CCreate%20pull%20request%E2%80%9D.

## History

TODO: Write history



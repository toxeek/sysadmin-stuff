![alt text](https://cdn.wccftech.com/wp-content/uploads/2015/09/First_Assault_group_shot_1442394288.png)


# Project Name

iSysadm - UNDER CONSTRUCTION !

### DISCLAIMER:
#### After adding the pentest section, including nse nmap scripts, I DO NOT HOLD MYSELF RESPONSIBLE of what you do if you install the tools, or how you use them. Even more if you use them for malicious intentions, you'll be reported if I detect you doing so, and you will be banned from many places.
```bash
## END OF DISCLAIMER
```

### PORTED TO RUN ON UBUNTU 20.04 TLS: *or make sure you have snap installed at least*

#### Now Devops oriented tools bootstrapping

## Installation

To install first clone the project as NON ROOT 
The cfg file where you toggle tools on/off is sysadmin.cfg file. So make sure you toggle the 
tools in sysadmin.cfg as you like (on/off/) and for the terraform version, make sure you toggle on tfevn, and that you select the terraform version you want installed.
so: 
```bash
$ git clone https://github.com/toxeek/sysadmin-stuff.git
$ cd sysadmin-stuff
$ sudo -s
(change to root)
# ./install.sh
```

## Usage
When you first clone it, cd into the sysadmin-stuff folder. There you will see a sysadminf.cfg file with a key=value format for the stuff that's to be installed (or not). if the value equals 1, then it will be installed. To disable that installation make the value to =0 instead. In the case of Terraform, single quote the version you want installed, make sure you toggle tfevn=1 tho .. as we use tfenv to install and manage terraform version/s we want installed.

***
#### sysadmin.cfg and other *.cfg files is where you toggle utils on/off
***
#### Added the pentest folder, so as with other utils, there is an utils.sh and pentest.cfg following the same structure as other utils, always look and setup.sh

#### added sipvicious for VOIP pentest research .. Remember sipvicious installs many tools:
###### sipvicious_svcrack   sipvicious_svcrash   sipvicious_svmap     sipvicious_svreport  sipvicious_svwar
##### so to get help with say, sipvicious_svcrack, do:
```bash
# sipvicious_svcrack --help
```
#### sipvicious github: https://github.com/EnableSecurity/sipvicious/blob/master/README.md
***
#### pentest directory:
```bash
# ls
nmap-nse  pentest.cfg  utils.sh
```

#### Also for nmap nse scripts, there is a subfolder into nmap-nse folder, for nse based nmap scripts installation, also following the structure of our utils within other parent directories:
```bash
root@trickylocalhost:/home/tricky/code/git/sysadmin-stuff# ls
LICENSE  README.md  chk_root.sh  helpers.sh  install.sh  pentest  setup.sh  sysadmin.cfg  utils.sh
root@trickylocalhost:/home/tricky/code/git/sysadmin-stuff# cd pentest/
root@trickylocalhost:/home/tricky/code/git/sysadmin-stuff/pentest# ls
nmap-nse  pentest.cfg  utils.sh
root@trickylocalhost:/home/tricky/code/git/sysadmin-stuff/pentest# cd nmap-nse/
root@trickylocalhost:/home/tricky/code/git/sysadmin-stuff/pentest/nmap-nse# ls
nse.cfg  utils.sh
```
#### option to enable installing the following pentest tools: ***(see pentest.cfg)***
![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "nse scripts")
1. ***nmap***
2. ***sqlpam***
4. ***sipvicious***

#### option to enable nse nmap scripts: ***(see nse.cfg)***
![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "nse scripts")
1. ***http-headers***
2. ***http-enum***
```bash
tricky@trickylocalhost:~/code/git/sysadmin-stuff$ pwd
/home/tricky/code/git/sysadmin-stuff
tricky@trickylocalhost:~/code/git/sysadmin-stuff$ ls
LICENSE  README.md  chk_root.sh  helpers.sh  install.sh  pentest  setup.sh  sysadmin.cfg  utils.sh
tricky@trickylocalhost:~/code/git/sysadmin-stuff$ cd pentest
tricky@trickylocalhost:~/code/git/sysadmin-stuff/pentest$ ls
nmap-nse  pentest.cfg  utils.sh
```
```bash
tricky@trickylocalhost:~/code/git/sysadmin-stuff/pentest$ cat pentest.cfg
## pentest utils
enable_pentest_utils=1
sqlmap=1
nmap=1
tricky@trickylocalhost:~/code/git/sysadmin-stuff/pentest$ ls
nmap-nse  pentest.cfg  utils.sh
tricky@trickylocalhost:~/code/git/sysadmin-stuff/pentest$ cd nmap-nse/
tricky@trickylocalhost:~/code/git/sysadmin-stuff/pentest/nmap-nse$ ls
nse.cfg  utils.sh
tricky@trickylocalhost:~/code/git/sysadmin-stuff/pentest/nmap-nse$ cat nse.cfg
## nmap nse scripts cfg
http-headers=1
http-enum=1
tricky@trickylocalhost:~/code/git/sysadmin-stuff/pentest/nmap-nse$ 
```

#### ***I do a nmap scan of an IP to show that you had http-headers nse script, and dependencies, installed correctly, and to serve as a PoC [do not expect me to show you how to exploit stuff]***

### so instead actually these are the steps to install the "goodies"
#### example of cloning and execution (see above as well, as does not matter where you clone)
```bash
$ mkdir -p ~/code/git && cd ~/code/git
$ git clone https://github.com/toxeek/sysadmin-stuff.git
$ tricky@trickylocalhost:~/code/git/sysadmin-stuff$ ls
LICENSE  README.md  chk_root.sh  install.sh  setup.sh  sysadmin.cfg  utils.sh
$ sudo -s 
> (input sudo pass, make sure install.sh has chmod +x, plus other shell scripts althouth I try to do it myself)
# ./install.sh
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History

TODO: Write history

## Credits

TODO: Write credits

=======
# sysadmin-stuff
sysadmin help to kick off an Ubuntu system with some goodies

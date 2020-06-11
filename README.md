# Project Name

iSysadm - UNDER CONSTRUCTION !

### Now Devops oriented tools bootrstrapping

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
#### syadmin.cfg still to be used properly *under construnction*
When you first clone it, cd into the sysadmin-stuff folder. There you will see a sysadminf.cfg file with a key=value format for the stuff that's to be installed (or not). if the value equals 1, then it will be installed. To disable that installation make the value to =0 instead.

## SYSADMIN.CFG NOW FULLY WORKING AND USED PROPERLY 
### so instead actually these are the steps to install the "goodies"
#### example of cloning and execution (see above as well, as does not matter where you clone)
```bash
$ mkdir -p ~/code/git && cd ~/code/git
$ git clone https://github.com/toxeek/sysadmin-stuff.git
$ tricky@trickylocalhost:~/code/git/sysadmin-stuff$ ls
LICENSE  README.md  ansible  chk_root.sh  install.sh  mysql_tunner  setup.sh  sysadmin.cfg  tmux  utils.sh
$ sudo -s 
> (input sudo pass)
# ./innstall.sh
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

# Project Name

iSysadm - UNDER CONSTRUCTION !

### Now Devops oriented tools bootrstrapping

## Installation

To install first clone the project

## Usage
#### syadmin.cfg still to be used properly *under construnction*
When you first clone it, cd into the sysadmin-stuff folder. There you will see a sysadminf.cfg file with a key=value format for the stuff that's to be installed (or not). if the value equals 1, then it will be installed. To disable that installation make the value to =0 instead.

As said abve, sysadmin.cfg still to be used porperly
### so instead actually these are the steps to install the "goodies"
```bash
$ mkdir -p ~/code/git && cd ~/code/git
$ git clone https://github.com/toxeek/sysadmin-stuff.git
$ tricky@trickylocalhost:~/code/git/sysadmin-stuff$ ls
LICENSE  README.md  ansible  chk_root.sh  install.sh  mysql_tunner  setup.sh  sysadmin.cfg  tmux  utils.sh
$ sudo -s 
> (input sudo pass)
# ./innstall.sh
```

### check the array in utils.sh, as those will be installed (until I cross reference the cfg file)

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

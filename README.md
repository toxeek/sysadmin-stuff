# Project Name

iSysadm

## Installation

To install first clone the project

## Usage

When you first clone it, cd into the sysadmin-stuff folder. There you will see a sysadminf.cfg file with a key=value format for the stuff that's to be installed (or not). if the value equals 1, then it will be installed. To disable that installation make the value to =0 instead.
It first kicks off some basic stuff with the script setup.sh, then it installs Ansible (if it is set in the cfg file as =1) and uses it to install stuff on localhost. This means that if you add hosts to the ansible host file, this could be installed in a remote Ubuntu machine too. 

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

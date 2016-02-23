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

## License

iSysadm, just kicks off a desktop at work with some sys admin goodies.
   Copyright (C) 2016 toxek.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA

=======
# sysadmin-stuff
sysadmin help to kick off an Ubuntu system with some goodies

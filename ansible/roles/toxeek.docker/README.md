Role Name
=========

A role that installs Docker on Ubuntu 14.04 (should be ok for others != 14.04)

Requirements
------------

This role requires Ansible 1.2 or higher.

Role Variables
--------------

there is one variable for the system that will be added to the docker group we create in the role. This variable is named system_user. 

Dependencies
------------

None.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: droplets
      roles:
         - { role: toxeek.docker, system_user: toxeek }

License
-------

BSD

Author Information
------------------

toxeek.

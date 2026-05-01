# Vagrant RnD
## Setup
  - virtualization enabled in BIO
  - hypervisor like "Virtual Box"
  - CLI
  - Vagrant tool
### MacOS
  - `brew install --cask vagrant`

### Linux

## Basic commands
- initiate `./Vagrantfile` - `vagrant init ${name_of_image}` 
	- `${name of image}` is taken from **Vagrant Cloud**
- `vagrant up` - install and start the vagrant box
- `vagrant halt` - stop/shutdown the vagrant box
- `vagrant destroy` - to delete the vagrant box
- reboot the machine after changes in Vagrantfile - `vagrant reload`
- get status of all VM on system - `vagrant global-status`

## ./scriptbox
- to start only one machine - run `vagrant up ${machine_name}`
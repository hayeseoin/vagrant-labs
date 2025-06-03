# Hyper-V Default Template

This guide explains how to deploy the default Hyper-V Vagrant template and describes its configuration.

Path: [`starter-templates/hyper-v/default-setup/Vagrantfile`](../starter-templates/hyper-v/default-setup/Vagrantfile)

## Quick Start

You can launch the template directly from the repo, or copy the Vagrantfile to a new directory:

```ps
vagrant up
```
The VMs should appear in Hyper-V and be accessible with SSH.

Remove the VMs with 

```ps
vagrant destroy -f
```
>Note: Must be run in PowerShell as Administrator, and with VAGRANT_PROVISIONED_SSH_KEY set as an environment variable pointing to your SSH public key (Windows path, e.g. C:\Users\you\.ssh\id_rsa.pub).

## Requirements

 - Vagrant installed on Windows
 - Hyper-V enabled
 - VAGRANT_PROVISIONED_SSH_KEY environment variable defined in Powershell
 - Vagrantfile resides on the Windows filesystem (not WSL paths)

## Vagrantfile Overview

### Virtual Machine Config

The virtual machine is configured by the `vm_settings` array
```ruby
vm_settings = [ 
  {   
    name: "al2023-node1",
    user_name: "ec2-user",
    box: "hayeseoin/al2023-hyperv",
    memory: 512, 
    cpus: 1 
  }
]
```
 - `name`: used as the VM name, hostname, and Vagrant identifier
 - `user_name`: user provisioned with your SSH key
 - `box`: Vagrant box to use
 - `memory`, `cpus`: Hyper-V resource allocation

### Set to use Default Switch

```ruby
config.vm.network "public_network", bridge: "Default Switch"
```
Uses Hyper-V's Default Switch for automatic networking. IPs will be assigned via NAT.


### Disable SMB Sharing

```ruby
config.vm.synced_folder ".", "/vagrant", disabled: true
```
You will be prompted during `vagrant up` if this is not set or disabled. Safest to keep it disabled if you're unsure about how to set up an SMB share (or if you just don't want to).

### VM Definition Loop
The `vm_settings` object is inserted to the virtual machine config steps as `|vm|` to configure the VMs via a loop, including provisioning the user:
```ruby
...
  vm_settings.each do |vm|
    config.vm.define vm[:name] do |node|
      node.vm.box = vm[:box]
      node.vm.hostname = vm[:name]

      node.vm.provider "hyperv" do |h|
        h.vmname = vm[:name]
        h.memory = vm[:memory]
        h.cpus   = vm[:cpus]
        h.enable_checkpoints = false
      end

      node.vm.provision "file", source: local_ssh_key, destination: "/home/vagrant/id_rsa.pub"
      node.vm.provision "shell", inline: create_user_shell(vm[:user_name])
    end
  end
...
```
### Provisioning
This function and variable should be included before the VM configuration to enable adding a user during provisioning time. 

`local_ssh_key` is the location of your public key, and must be saved to your Windows file system. e.g. `C:\\Users\\eoaha\\dev\\wsl-ssh-key\\id_rsa.pub`. The environment variable `VAGRANT_PROVISIONED_SSH_KEY` must be in your **Powershell** environment, not your bash environment. 

```ruby
local_ssh_key = File.expand_path("$VAGRANT_PROVISIONED_SSH_KEY", __dir__)
def create_user_shell(username)
<<-SHELL
    useradd -m -s /bin/bash #{username}
    mkdir -p /home/#{username}/.ssh
    cp /home/vagrant/id_rsa.pub /home/#{username}/.ssh/authorized_keys
    chown -R #{username}:#{username} /home/#{username}/.ssh
    chmod 700 /home/#{username}/.ssh
    chmod 600 /home/#{username}/.ssh/authorized_keys
    echo "#{username} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/#{username}
SHELL
end
```
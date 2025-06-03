# Hyper-V Starter Templates

These are templates for deploying Hyper-V VMs with Vagrant. There are global config settings, and per VM config settings. These templates use the Defautl Switch, disable SMB sharing, disables checkpoints and injects an SSH key and user at provisioning time. If the switch and SMB config are not declared in the condig, you will be prompted for them during `vagrant up`.

Vagrant must be run in a Powershell admin terminal to use the Hyper-V provider. If using WSL please see this guide on [Using Vagrant with Hyper-V and WSL](using-vagrant-with-hyper-v-and-wsl)

This can be used with [Hyper-V Hosts Manager](https://github.com/hayeseoin/hyper-v-hosts-manager) if you want VMs to be accessible via hostname instead of IP alone. 

The descriptions below reference the [default virtual machine deployment](starter-templates/hyper-v/default-setup/Vagrantfile)

## Global Config

### Set to use Default Switch

```ruby
config.vm.network "public_network", bridge: "Default Switch"
```

### Disable SMB Sharing
You will be prompted during `vagrant up` if this is not set or disabled. Safest to keep it disabled if you're unsure about how to set up an SMB share (or if you just don't want to).

```ruby
config.vm.synced_folder ".", "/vagrant", disabled: true
```

## Virtual Machine Config

The virtual machine is configured by the JSON object `vm_settings`
```ruby
vm_settings = [ 
  {   
    name: "al2023-node1",
    user_name: "eoinh",
    box: "hayeseoin/al2023-hyperv",
    memory: 512, 
    cpus: 1 
  }
]
```
`name` will be the name of the Hyper-V VM, the Vagrant object and the internal hostname of the VM.


### Virtual Machine Settings
The `vm_settings` object is inserted to the virtual machine config steps as `|vm|`
```ruby
...
  vm_settings.each do |vm|
    config.vm.define vm[:name] do |node|
      node.vm.box = vm[:box]
      node.vm.hostname = vm[:name]
...
```

These settings are the box being used, and the internal hostname of the VM
```ruby
...
    node.vm.box = vm[:box]
    node.vm.hostname = vm[:name]
...
```
### Hyper-V Specific Settings
This block sets the Hyper-V specific settings (in this case it will be 512 MB and 1 CPU core). Enable checkpoints if you want to use them.
```ruby
...
    node.vm.provider "hyperv" do |h|
        h.vmname = vm[:name]
        h.memory = vm[:memory]
        h.cpus   = vm[:cpus]
        h.enable_checkpoints = false
    end
...
```
### Provision user
This provisions the user and injects the SSH key
```ruby
...
    node.vm.provision "file", source: local_ssh_key, destination: "/home/vagrant/id_rsa.pub"
    node.vm.provision "shell", inline: create_user_shell(vm[:user_name])
end
...
```
## Provisioning
This function and variable should be included to enable adding a user during provisioning time. 

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
To create a user during provision, add the folloing to the VM config (more details further down):
```ruby
node.vm.provision "file", source: local_ssh_key, destination: "/home/vagrant/id_rsa.pub"
node.vm.provision "shell", inline: create_user_shell("some-user-name")
```
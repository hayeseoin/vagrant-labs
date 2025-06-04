# Ansible Provisioning

This Vagrantfile provisions an AL2023 VM with apache using an ansible playbook. 

Normally, the ansible_local provisioner would be used when using the Hyper-V provider with Vagrant. However, this requires a fragile (and frustrating) SMB share setup. To workaround this, simply install Ansible with the shell provisioner, copy the playbook to the VM, and run the ansible playbook locally. No need to use the Vagrant provisioner. 

### Custom Ansible Provisioner 

```ruby
  ansible_playbook = File.expand_path("./playbook.yml", __dir__)
  def ansible_provision(install, playbook)
    <<-SHELL
      echo "Checking if Ansible is installed..."
      if ! command -v ansible >/dev/null 2>&1; then
        echo "Installing Ansible."
        #{install}
      else
        echo "Ansible already installed"
      fi
      ansible-playbook -i "127.0.0.1," -c local #{playbook}
    SHELL
  end
  ```
This function is essentially a custom ansible provisioner. 

First, copy the Ansible playbook from the host to the VM.

`install` - The installation command for Ansible for whatever distro you are running. e.g. `dnf install -y ansible`  
`playbook` - The location of the playbook inside the VM. e.g. `/tmp/playbook.yml`

### VM Parameters 

```ruby
vm_settings = [ 
{   
    name: "al2023-ansible-test",
    user_name: "ec2-user",
    box: "hayeseoin/al2023-hyperv",
    memory: 1024, 
    cpus: 1,
    ansible_install: "dnf install -y ansible",
    ansible_playbook: "/tmp/playbook.yml"
}
]
  ```
The array the VM will take will include the installation command and the playbook's location.

### Provisioning

```ruby
node.vm.provision "shell", inline: ansible_provision(vm[:ansible_install], vm[:ansible_playbook])
```
Provision by inserting the variables for the ansible install command, and the playbook location, from the `vm_settings` array (added to the VM config block with `|vm|`).
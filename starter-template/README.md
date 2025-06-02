# Starter Template

This template deploys 2 Hyper-V VMs. They are deployed on the Default Switch, with no SMB share, and with default keys injected at provision time so that SSH from WSL is possible.

Here is a minimal one VM setup:

```ruby
Vagrant.configure("2") do |config|
  config.vm.network "public_network", bridge: "Default Switch"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Copy public key from WSL home to a user called ansible
  local_ssh_key = File.expand_path("\\\\wsl.localhost\\Debian\\home\\eoinh\\.ssh\\id_rsa.pub", __dir__)
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

  # Virtual Machine
  config.vm.define "01-al2023" do |node|
    settings = { 
      box: "hayeseoin/al2023-hyperv",
      name: "01-al2023", 
      hostname: "01-al2023", 
      vmname: "01-al2023",
      memory: 1024, 
      cpus: 2
    }
    node.vm.box = settings[:box]
    node.vm.hostname = settings[:hostname]
    node.vm.network "public_network", bridge: "Default Switch"

    node.vm.provider "hyperv" do |h|
      h.vmname = settings[:vmname]
      h.memory = settings[:memory]
      h.cpus   = settings[:cpus]
      h.enable_checkpoints = false
    end
    
    node.vm.provision "file", source: local_ssh_key, destination: "/home/vagrant/id_rsa.pub"
    node.vm.provision "shell", inline: create_user_shell("eoinh")
  end
end
```
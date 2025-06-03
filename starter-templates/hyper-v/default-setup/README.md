# Default Hyper-V Template

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

If multiple objects are added to this array in this format, multiple VMs will be setup via loop. Full description in [`hyper-v-default-template`](../../../docs/hyper-v-default-template.md)
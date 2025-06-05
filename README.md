# Vagrant Labs

Reusable lab environment templates for exploring infrastructure tooling.

Designed for:
- Windows 10/11 with WSL2
- Vagrant with Hyper-V or Libvirt
- Optional tools for enhanced usability

## Getting Started

### Environment setup
See [`docs/start-guide.md`](docs/start-guide.md) for instructions on how to set up the environment.

### Launching and editing templates
See [`docs/hyper-v-base-template.md`](docs/hyper-v-base-template.md) for how to deploy Vagrant templates and understand the Vagrantfile structure used in this repo.

See [`docs/ansible-with-hyper-v.md`](docs/ansible-with-hyper-v.md) for steps on Ansible provisioning with Hyper-V.

## Labs

[**`ansible-vagrant-hyper-v`**](ansible-vagrant-hyper-v) - Provisioning a VM with a custom ansible provisioning function.

## Related Resources

### [Hyper-V Hosts Manager](https://github.com/hayeseoin/hyper-v-hosts-manager)  
Automatically syncs Hyper-V VM IPs into the Windows hosts file and enables WSL-to-VM networking.

### [al2023-on-hyper-v](https://github.com/hayeseoin/al2023-on-hyper-v)  
Archived setup guide and templates for running Amazon Linux 2023 under Hyper-V and with Vagrant.

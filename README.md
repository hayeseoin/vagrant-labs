# Vagrant Labs

This repository is a collection of reusable Vagrant lab templates for local experimentation and infrastructure prototyping. It primarily targets Hyper-V with future support planned for libvirt/KVM environments.

## Requirements

- Windows 10/11 with Hyper-V enabled
- Vagrant (>= 2.3.x)
- (Optional) WSL2 for shell scripting or cloud-init generation

Refer to the [Virtualization Lab Setup](https://github.com/hayeseoin/virtualization-lab-setup) for complete tooling configuration and environment preparation.

## Starter templates

### [Hyper-V ](starter-templates/hyper-v)

- [`default-setup`](starter-templates/hyper-v/default-setup) - Single VM with SSH key injection.
- [`multi-vm`](starter-templates/hyper-v/multi-vm) - Basic multi-VM topology.
- [`duplicate-vms`](starter-templates/hyper-v/duplicate-vms) - For scaling with consistent configs.
- [`single-vm`](starter-templates/hyper-v/single-vm) - Minimal config.

Vagrant must be run in a Powershell admin terminal to use the Hyper-V provider. If using WSL please see this guide on [Using Vagrant with Hyper-V and WSL](using-vagrant-with-hyper-v-and-wsl)

### [libvirt](starter-templates/libvirt)

Planning templates for use with Linux and KVM/libvirt.

## SSH Access

To simplify local SSH access, see:
[`ssh-config/README.md`](ssh-config)

You may want to suppress strict host key checking for local labs.
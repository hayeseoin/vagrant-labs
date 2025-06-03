# Vagrant Labs

Reusable lab environment templates for exploring infrastructure tooling.

Designed for:
- Windows 10/11 with WSL2
- Vagrant with Hyper-V or Libvirt
- Optional tools for enhanced usability

## Getting Started

See [docs/start-guide.md](docs/start-guide.md) for setup instructions.

## Starter templates

### [Hyper-V ](starter-templates/hyper-v)

- [`default-setup`](starter-templates/hyper-v/default-setup) - Single VM with SSH key injection.
- [`multi-vm`](starter-templates/hyper-v/multi-vm) - Basic multi-VM topology.
- [`duplicate-vms`](starter-templates/hyper-v/duplicate-vms) - For scaling with consistent configs.
- [`single-vm`](starter-templates/hyper-v/single-vm) - Minimal config.

Vagrant must be run in a Powershell admin terminal to use the Hyper-V provider. If using WSL please see this guide on using Vagrant with Hyper-V and WSL: [`docs/using-vagrant-with-wsl-and-hyper-v.md`](docs/using-vagrant-with-wsl-and-hyper-v.md)

### [libvirt](starter-templates/libvirt)

Planning templates for use with Linux and KVM/libvirt.
# Getting Started with Vagrant Labs

This guide walks you through setting up your local environment to run the Vagrant labs provided in this repo. It includes instructions for using **WSL2 with Hyper-V**. Support for **Libvirt** is planned for the future.

---
### Quick Start
Install WSL (optional)  
Enable Hyper-V  
Install Vagrant (Windows)  
Install and set up [**Hyper-V Hosts Manager**](https://github.com/hayeseoin/hyper-v-hosts-manager)  
If using WSL, enable for use with vagrant following [`using-vagrant-with-wsl-and-hyper-v.md`](using-vagrant-with-wsl-and-hyper-v.md)  
Run the [**base-template**](../starter-templates/hyper-v/base-template/) to start  

---

## Prerequisites

- Windows 10/11
- WSL2 (Debian-based recommended)
- PowerShell (Admin access required for some steps)
- Hyper-V enabled
- Vagrant (installed on Windows)
- [Hyper-V Hosts Manager](https://github.com/hayeseoin/hyper-v-hosts-manager) (custom tool making Hyper-V instances easier to access)

## Environment Setup

### 1. Install WSL2 (optional)
Follow Microsoft’s [official guide](https://learn.microsoft.com/en-us/windows/wsl/install) to install WSL2 with a Debian distro (or any distro you like).

If you don't want to use WSL2, you can just run with Powershell alone.

### 2. Enable Hyper-V
Ensure Hyper-V is enabled from Windows Features or via PowerShell: 

```ps
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```
Official guide [**Enable Hyper-V**](https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/get-started/install-hyper-v)

### 3. Install Vagrant on Windows
Download and install from [https://developer.hashicorp.com/vagrant/install](https://developer.hashicorp.com/vagrant/install)

Make sure it's installed on Windows, not inside WSL.

### 4. Working with Hyper-V from WSL
Follow this step if using WSL2 as your main interface. See: [`using-vagrant-with-wsl-and-hyper-v.md`](using-vagrant-with-wsl-and-hyper-v.md) for full instructions. This doc describes setting up a link between the WSL and Windows filesystems, and launching a powershell admin terminal from WSL. 

### 5. Networking Helpers
By default, Hyper-V’s Default Switch assigns dynamic IPs that WSL can't easily reach. For best results:

Set up [**Hyper-V Hosts Manager**](https://github.com/hayeseoin/hyper-v-hosts-manager) for IP forwarding and name resolution.

> Optional: PowerShell one-liner to enable WSL-to-VM routing:
>
> ```ps
> Get-NetIPInterface | where {
>  $_.InterfaceAlias -eq 'vEthernet (WSL (Hyper-V firewall))' -or
>  $_.InterfaceAlias -eq 'vEthernet(Default Switch)'
>} | Set-NetIPInterface -Forwarding Enabled -Verbose
>```

### 6. SSH Config (Optional)
The templates in this repo inject an SSH key from the Powershell environment into the VMs. Set up the environment variable `VAGRANT_PROVISIONED_SSH_KEY` in Powershell which points to the location of your public key. [Power Toys Environment Variables](https://learn.microsoft.com/en-us/windows/powertoys/environment-variables) is helpful for this.

```ps
> $env:VAGRANT_PROVISIONED_SSH_KEY
C:\\Users\\eoaha\\dev\\wsl-ssh-key\\id_rsa.pub
``` 
If using WSL, make sure the a copy of your public key is saved somewhere in the Windows filesystem.

This is covered in more detail in the documentation for the default Hyper-V template: [`docs/hyper-v-baset-template.md`](hyper-v-base-template.md)

You may consider reviewing [`ssh-config.md`](ssh-config.md) for how to generate a local SSH config that suppresses known-hosts warnings for local VMs.
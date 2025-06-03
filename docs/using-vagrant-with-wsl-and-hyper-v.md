# Using Vagrant with Hyper-V and WSL

This guide explains how to use Vagrant with the Hyper-V provider when your primary development environment is WSL2.

## Background

Vagrant cannot run inside the WSL2 environment if using the Hyper-V provider.

It must be run from Windows, in an elevated PowerShell terminal.

WSL-based paths (like /home/user/...) cannot be used as the Vagrant root — the project must be on the Windows file system (e.g., /mnt/c/...).

## Recommended Setup

### 1. Create a shared directory on the Windows filesystem

```sh
mkdir /mnt/c/Users/<your_user>/vagrant-lab
ln -s /mnt/c/Users/<your_user>/vagrant-lab ~/dev/vagrant-lab
```

Use this folder (~/dev/vagrant-lab) as your working directory from WSL.

Important: This symlink ensures that:

 - You can edit files from WSL with Unix tools
 - You can run Vagrant from PowerShell in a valid location

### 2. Launch PowerShell as Admin (in correct directory)

Use this helper script to launch an admin PowerShell session from WSL: [`resources/launch-ps-admin-shell.sh`](../resources/launch-ps-admin-shell.sh)

This opens an Admin PowerShell terminal in the same directory (on the Windows side) where you can run:
```ps
vagrant up
vagrant destroy -f
```
You can add a shell alias like below to pop open a usable shell when needed.

```
alias psadmin='/path/to/launch-ps-admin-shell.sh'
```

### 3. Networking Considerations

If you're using Hyper-V’s Default Switch, VMs will get dynamic IPs and won’t be accessible from WSL without a small network forwarding tweak.

To enable connectivity from WSL to Hyper-V:

```ps
Get-NetIPInterface | where {
  $_.InterfaceAlias -eq 'vEthernet (WSL (Hyper-V firewall))' -or
  $_.InterfaceAlias -eq 'Default Switch'
} | Set-NetIPInterface -Forwarding Enabled -Verbose
```

You can automate this by setting up [Hyper-V Hosts Manager](https://github.com/hayeseoin/hyper-v-hosts-manager) to persist this and set up name resolution via the hosts file.

### 4. SSH Config for Convenience (Optional)

See [`ssh-config.md`](ssh-config.md) for how to generate a local SSH config that suppresses known-hosts warnings.
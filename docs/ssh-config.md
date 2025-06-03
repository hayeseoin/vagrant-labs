# SSH Config

Since the machines attached to the hostnames and IPs are always changing, you will get contatnt notifications to remove them from `.ssh/known_hosts` while trying to access with SSH. To resolve this, you may make sure all VMs in your hosts file have a `.local` TLD, and add the following to your `.ssh/config` file:

**Disclaimer:** This is technicallyl insecure and should only be used for local VMs. You will be susceptible to man-in-the-middle attacks in the event that someone, somehow, spoofs a `.local` domain. This should only be possible if the domain is not already in your hosts file, and if you are connceted to a malicious DNS server (`.local` domains don't resolve to the internet on legitimate DNS servers). This is unlikely, but not impossible.

```
Host *.local
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```

A more secure, but less convenient option, is to ssh with strict checking disabled inline, e.g.

```sh
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null eoinh@al2023-node1.local
```
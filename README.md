# Server Utils

## LDAP client configuration

```
sudo sh -c "$(wget https://raw.githubusercontent.com/frantp/server-utils/master/ldap_setup.sh -O -)"
```

## libvirt static IP and port forwarding

1. Copy `set_iptables.sh` to `/etc/libvirt/hooks/qemu` in the host machine.
2. Locally or remotely: install dependency (```python3-libvirt```) and run `virtip.py`.

# Server Utils

## LDAP client configuration

Run:
```
sudo sh -c "$(wget https://raw.githubusercontent.com/frantp/server-utils/master/ldap_setup.sh -O -)"
```

## System-wide oh-my-zsh configuration

Run:
```
sudo sh -c "$(wget https://raw.githubusercontent.com/frantp/server-utils/master/oh-my-zsh_setup.sh -O -)"
```

## libvirt static IP and port forwarding

1. Copy `set_iptables.sh` to `/etc/libvirt/hooks/qemu` in the host machine.
2. Locally or remotely: install dependency (```python3-libvirt```) and run `virtip.py`.

## MATLAB non-GUI script execution

Install MATLAB and run:
```
MATLAB_DIR="$(dirname $(which matlab))"
sudo wget https://raw.githubusercontent.com/frantp/server-utils/master/matlab-run -P "$MATLAB_DIR"
sudo chmod +x "$MATLAB_DIR/matlab-run"
```

Then, you can use `matlab-run <foo>`.

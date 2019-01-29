#!/usr/bin/python3
'''Fix IP of the VM and forward port 22<IP> on the host to port 22 on the VM.
'''

import sys
import libvirt
import xml.etree.ElementTree as ET
import subprocess as sp

# Global variables
PROTO = 'qemu+ssh'
HOOKS_CFG_FILE = '/etc/libvirt/hooks/qemu'

# Parameters
usrv    = sys.argv[1] if len(sys.argv) > 1 else input('User@server: ')
network = sys.argv[2] if len(sys.argv) > 2 else input('Network: ')
vmname  = sys.argv[3] if len(sys.argv) > 3 else input('VM name: ')
ipid    = sys.argv[4] if len(sys.argv) > 4 else input('IP term: ')

# Fix IP of the VM
conn_str = '{}://{}/system'.format(PROTO, usrv)
with libvirt.open(conn_str) as conn:
    # Get MAC address of VM
    try:
        dom = conn.lookupByName(vmname)
    except libvirt.libvirtError as e:
        print(e)
        exit(1)
    elem = ET.fromstring(dom.XMLDesc(0))
    mac = elem.find('.//interface/mac').get('address')

    # Get interface IP and set static IP for VM
    try:
        network = conn.networkLookupByName(network)
    except libvirt.libvirtError as e:
        print(e)
        exit(1)
    elem = ET.fromstring(network.XMLDesc(0))
    ipelem = elem.find('ip')
    iprest = '.'.join(ipelem.get('address').split('.')[:-1])
    ip = iprest + '.' + ipid
    elem.find('.//dhcp').append(ET.Element('host',
        attrib={'mac': mac, 'name': vmname, 'ip': ip}))
    conn.networkDefineXML(ET.tostring(elem).decode())

# Forward port 22<IP> on the host to port 22 on the VM
sp.call(['ssh', usrv,
    'echo "set_iptables \\$1 \\$2 {} {} 22 22{}"'
    ' >> {}; sudo service libvirtd restart'
    .format(vmname, ip, ipid, HOOKS_CFG_FILE)])

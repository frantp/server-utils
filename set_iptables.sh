#!/bin/bash

function set_iptables {
    EVENT_NAME=$1
    EVENT_TYPE=$2
    GUEST_NAME=$3
    GUEST_IP=$4
    GUEST_PORT=$5
    HOST_PORT=$6
    if [ "$EVENT_NAME" = "$GUEST_NAME" ]; then
        if [ "$EVENT_TYPE" = "stopped" ] || [ "$EVENT_TYPE" = "reconnect" ]; then
            /sbin/iptables -D FORWARD -o virbr0 -d  $GUEST_IP -j ACCEPT
            /sbin/iptables -t nat -D PREROUTING -p tcp --dport $HOST_PORT -j DNAT --to $GUEST_IP:$GUEST_PORT
        fi
        if [ "$EVENT_TYPE" = "start" ] || [ "$EVENT_TYPE" = "reconnect" ]; then
            /sbin/iptables -I FORWARD -o virbr0 -d  $GUEST_IP -j ACCEPT
            /sbin/iptables -t nat -I PREROUTING -p tcp --dport $HOST_PORT -j DNAT --to $GUEST_IP:$GUEST_PORT
        fi
    fi
}


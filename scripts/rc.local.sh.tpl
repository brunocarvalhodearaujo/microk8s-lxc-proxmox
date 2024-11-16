#!/usr/bin/env bash

cat > /etc/rc.local <<EOF
#!/bin/bash

# If this symlink is missing, likely microk8s isn't running
if ! [ -f /dev/kmsg ]; then
  ln -s /dev/console /dev/kmsg
  apparmor_parser -r /var/lib/snapd/apparmor/profiles/*
fi

if ! [ -x "$(command -v microk8s)" ]; then
  microk8s stop
  microk8s start
fi
EOF

chmod +x /etc/rc.local

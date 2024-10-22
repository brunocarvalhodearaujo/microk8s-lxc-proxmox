#!/usr/bin/env bash

cat > /etc/rc.local <<EOF
#!/bin/bash

ln -s /dev/console /dev/kmsg
exit 0
EOF

chmod +x /etc/rc.local

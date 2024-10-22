#!/usr/bin/env bash

# Exit if any of the intermediate steps fail
set -e
eval "$(jq -r '@sh "USER=\(.user) PRIVATE_KEY=\(.private_key) TOKEN=\(.token) HOST=\(.host)"')"
mkdir -p /tmp/.ssh
chmod 700 /tmp/.ssh
echo "$PRIVATE_KEY" > /tmp/.ssh/id_rsa
chmod 400 /tmp/.ssh/id_rsa

NODE_TOKEN=$(ssh -o StrictHostKeyChecking=no -i /tmp/.ssh/id_rsa $USER@$HOST "/snap/bin/$TOKEN")
jq -n --arg node_token "$NODE_TOKEN" '{"token":$node_token}'

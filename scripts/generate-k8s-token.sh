#!/usr/bin/env bash

# Exit if any of the intermediate steps fail
set -e
eval "$(jq -r '@sh "USER=\(.user) PRIVATE_KEY=\(.private_key) HOST=\(.host)"')"
mkdir -p /tmp/.ssh
chmod 700 /tmp/.ssh
echo "$PRIVATE_KEY" > /tmp/.ssh/id_rsa
chmod 400 /tmp/.ssh/id_rsa

ACCESS_TOKEN=$(ssh -o StrictHostKeyChecking=no -i /tmp/.ssh/id_rsa $USER@$HOST "kubectl create token default --duration=999999999s")

jq -n --arg access_token "$ACCESS_TOKEN" '{"access_token":$access_token}'

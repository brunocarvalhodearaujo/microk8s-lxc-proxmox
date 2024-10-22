#!/usr/bin/env bash

sleep 30

pct exec ${vmid} -- bash -c '/snap/bin/microk8s add-node --format short' | pct exec ${master_vmid} -- bash -c "/snap/bin/$(xargs)"

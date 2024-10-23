#!/usr/bin/env bash

apt update
apt upgrade -y

printf "🛠️ Installing Linux dependencies\n"
apt install -y \
  ca-certificates \
  curl \
  avahi-daemon \
  make \
  zip \
  unzip \
  htop \
  net-tools \
  squashfuse \
  fuse \
  apache2-utils \
  snapd

printf "🛠️ Installing and configure microk8s\n"

snap install microk8s --classic
snap alias microk8s.helm3 helm
snap alias microk8s.kubectl kubectl
microk8s enable ingress
sleep 60
microk8s status --wait-ready

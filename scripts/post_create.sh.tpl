#!/usr/bin/env bash

apt update

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

snap install microk8s --classic
snap alias microk8s.helm3 helm
snap alias microk8s.kubectl kubectl
microk8s enable ingress
microk8s status --wait-ready

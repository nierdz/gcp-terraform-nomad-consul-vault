#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

/bin/systemctl stop consul.service
/bin/systemctl stop vault.service
rm -rf /var/consul/*
rm -rf /var/vault/*

su - admin -c "cd /home/admin/ansible; TAGS=consul,vault make -f ../Makefile run-ansible"

#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

/bin/systemctl stop consul.service
rm -rf /var/consul/*

su - admin -c "cd /home/admin/ansible; TAGS=consul,vault make -f ../Makefile run-ansible"

/bin/systemctl start vault.service

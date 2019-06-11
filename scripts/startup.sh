#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

/bin/systemctl stop consul.service
/bin/systemctl stop nomad.service
rm -rf /var/consul/*
rm -rf /var/nomad/*

su - admin -c "cd /home/admin; /home/admin/venv/bin/ansible-playbook -t consul playbook.yml"
su - admin -c "cd /home/admin; /home/admin/venv/bin/ansible-playbook -t nomad playbook.yml"

#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

/bin/systemctl stop consul.service
#/bin/systemctl stop nomad.service
rm -f /var/consul/node-id
#rm -f /var/nomad/client/client-id

su - admin -c "cd /home/admin; /home/admin/venv/bin/ansible-playbook -t consul playbook.yml"
#su - admin -c "cd /home/admin; /home/admin/venv/bin/ansible-playbook -t nomad playbook.yml"

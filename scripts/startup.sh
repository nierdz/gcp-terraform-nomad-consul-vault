#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

/bin/systemctl stop consul.service
rm -f /var/consul/node-id

su - admin -c "cd /home/admin; /home/admin/venv/bin/ansible-playbook -t consul playbook.yml"

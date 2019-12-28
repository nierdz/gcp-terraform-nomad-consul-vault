#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

su - admin -c "cd /home/admin/ansible; TAGS=consul,vault make -f ../Makefile run-ansible"

/bin/systemctl start vault.service
/bin/systemctl start consul.service

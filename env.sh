#! /usr/bin/env/bash

# Gcloud and Packer
export GCE_PROJECT=nomad-consul-vault
export GCE_PEM_FILE_PATH=~/.gcloud/nomad-consul-vault.json
export CLOUDSDK_ACTIVE_CONFIG_NAME=$GCE_PROJECT
export GOOGLE_APPLICATION_CREDENTIALS=~/.gcloud/nomad-consul-vault.json
export GOOGLE_PROJECT=$GCE_PROJECT
if [[ -f "$GOOGLE_APPLICATION_CREDENTIALS" ]]; then
  GCE_EMAIL=$(grep client_email $GCE_PEM_FILE_PATH | grep -oE "[0-9a-z\\-]*@[0-9a-z\\-]*\\.iam\\.gserviceaccount\\.com")
  export GCE_EMAIL
fi

# Terraform
export TF_VAR_project_name=$GCE_PROJECT
export TF_VAR_region=europe-west1

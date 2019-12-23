#! /usr/bin/env/bash

export GCE_PROJECT=your-project-name
export GCE_PEM_FILE_PATH=~/.gcloud/your-project-name.json
export CLOUDSDK_ACTIVE_CONFIG_NAME=$GCE_PROJECT
export GOOGLE_APPLICATION_CREDENTIALS=~/.gcloud/your-project-name.json
export GOOGLE_PROJECT=$GCE_PROJECT
GCE_EMAIL=$(grep client_email $GCE_PEM_FILE_PATH | grep -oE "[0-9a-z\\-]*@[0-9a-z\\-]*\\.iam\\.gserviceaccount\\.com")
export GCE_EMAIL
export TF_VAR_project_name=$GCE_PROJECT

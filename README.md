# Run Nomad, Consul, Vault on top of GCP

This small project is a POC to run some kind of applications on GCP using some Hashicorp tools:

- Terraform
- Nomad
- Consul
- Vault

### First, setup gcloud

I will not explain this step in details cause this is not the interesting part of this tutorial and you can find plenty of informations online.

1. You need to install [gcloud sdk](https://cloud.google.com/sdk/install)
2. Go to Google cloud console and create a new project called `terraform-nomad-consul-vault`
3. Go to **IAM & admin**, then **Service Accounts** and create a service account with **Project owner** role.
4. Create a json key associate to this service account and rename it to `terraform-nomad-consul-vault.json` (we will use this key to do everything related to this GCP project)
5. Put this key inside `~/.gcloud/terraform-nomad-consul-vault.json` and setup your project with this bunch of gcloud commands:
```
gcloud config configurations create terraform-nomad-consul-vault --no-activate
export CLOUDSDK_ACTIVE_CONFIG_NAME=terraform-nomad-consul-vault
gcloud --configuration terraform-nomad-consul-vault config set project terraform-nomad-consul-vault
gcloud auth activate-service-account --key-file ~/.gcloud/terraform-nomad-consul-vault.json
```
6. Source `env.sh` to export some important environment variables and you should be ready to use **gcloud**
```
source env.sh
```

To check everything is good, you should try to list your glcoud configurations and you should have something like this:
```
gcloud config configurations list
NAME                 IS_ACTIVE  ACCOUNT                                             PROJECT              DEFAULT_ZONE  DEFAULT_REGION
default              False
terraform-nomad-consul-vault  True       nierdz@terraform-nomad-consul-vault.iam.gserviceaccount.com  terraform-nomad-consul-vault
```

And everytime you need to work on this project, just source `env.sh`.

### Next, we'll configure backend to store tfstate

For this, we'll use a **GCP bucket**. To create it:
```
gsutil mb -p ${GCE_PROJECT} gs://${GCE_PROJECT}
```

Enable versioning:
```
gsutil versioning set on gs://${GCE_PROJECT}
```

To use this bucket, we have [backend.tf](backend.tf)

### Packer to bake image
```
packer build -var "image_name=tncv-image" tncv-packer.json
```

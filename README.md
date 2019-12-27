# Run Nomad, Consul, Vault on top of GCP

This small project is a POC to run some kind of applications on GCP using some Hashicorp tools:

- Terraform
- Nomad
- Consul
- Vault

## Requirements

- You need to have terraform >0.12 installed and in your **PATH**
- You need to have packer installed and in your **PATH**

### Setup `env.sh` and use it

This file will be used to export some environment variables usefull to run **gcloud**, **terraform** and **packer**.
You need to replace all occurences of `nomad-consul-vault` with `your-actual-project-name`.
For example, I just named my GCP project `un-nom-de-projet` so I need to run this command:
```
sed -i 's/nomad-consul-vault/un-nom-de-projet/g' env.sh
```

You can also change `TF_VAR_region` to use another region.

As for now, you need to source this file before doing anything else, let's do it:
```
source env.sh
```

### Setup gcloud

I will not explain this step in details cause this is not the interesting part of this tutorial and you can find plenty of informations online.

1. You need to install [gcloud sdk](https://cloud.google.com/sdk/install)
2. Go to Google cloud console and create a new project.
3. Go to **IAM & admin**, then **Service Accounts** and create a service account with **Project owner** role.
4. Create a json key associate to this service account and rename it to `your-actual-project-name.json` (this key will be used by gcloud)
5. Put this key inside `~/.gcloud/your-actual-project-name.json` and setup your project with this bunch of gcloud commands:
```
gcloud config configurations create your-actual-project-name --no-activate
gcloud --configuration your-actual-project-name config set project your-actual-project-name
gcloud auth activate-service-account --key-file ~/.gcloud/your-actual-project-name.json
```

To check everything is good, you should try to list your glcoud configurations and you should have something like this:
```
gcloud config configurations list
NAME                IS_ACTIVE  ACCOUNT                                            PROJECT             DEFAULT_ZONE  DEFAULT_REGION
default             False
nomad-consul-vault  True       nierdz@nomad-consul-vault.iam.gserviceaccount.com  nomad-consul-vault
```

### Enable APIs

```
gcloud services enable iam.googleapis.com
gcloud services enable cloudkms.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
```

### Configure bucket to store tfstate

```
gsutil mb -p ${GCE_PROJECT} gs://${GCE_PROJECT}
gsutil versioning set on gs://${GCE_PROJECT}
```

To use this bucket, we have [backend.tf](terraform/backend.tf)

### Google cloud KMS

You can either setup a keyring and a key to unseal vault via terraform or via CLI using **glcoud**. I prefer **glcoud** method as keyring and key can not be deleted quickly so it's better to leave this ressources off terraform if you want to create and destroy your infrastructure several times on the same GCP project. Here is a make task to do it:
```
make create-key
```

If you only want to build this project once and never use `terraform destroy` you can uncomment lines related to `google_kms_key_ring` and `google_kms_crypto_key` in [iam.tf](terraform/iam.tf).

### Packer to bake images

Now, we need to build images and for this, we'll use packer. Here is a task for this:
```
make run-packer
```

### Terraform to create and deploy everything

To create all our infrastructure in GCP, we'll use **terraform**. Here is task for this:
```
make run-terraform
``

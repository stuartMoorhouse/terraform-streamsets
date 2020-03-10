# StreamSets on Digital Ocean
A Terraform template for running the StreamSets Docker image on a Digital Ocean Droplet. 

This template:

* Creates one Digital Ocean Ubuntu Docker Droplet
* Pulls the StreamSets Docker image and runs it
* Changes the Admin user's default password
* Creates a user and assigns them a password

This template requires the following parameters to be set as environment variables

* $DIGITALOCEAN_ACCESS_TOKEN
* $FINGERPRINT
* $ADMINPASSWORD

## Create the infrastructure

```
terraform apply \
  -var "do_token=${DIGITALOCEAN_ACCESS_TOKEN}" \
  -var "pub_key=$HOME/.ssh/DigitalOcean_rsa.pub" \
  -var "pvt_key=$HOME/.ssh/DigitalOcean_rsa" \
  -var "ssh_fingerprint=$FINGERPRINT" \
  -var "admin_password=$ADMINPASSWORD"
  ```

## Destroy the infrastructure

```
terraform plan -destroy -out=terraform.tfplan \
  -var "do_token=${DIGITALOCEAN_ACCESS_TOKEN}" \
  -var "pub_key=$HOME/.ssh/DigitalOcean_rsa.pub" \
  -var "pvt_key=$HOME/.ssh/DigitalOcean_rsa" \
  -var "ssh_fingerprint=$FINGERPRINT" \
  -var "admin_password=$ADMINPASSWORD"

terraform apply terraform.tfplan
```
# terraform-proxmox-bitnami-wp

This terraform code will deploy bitnami wordpress in a proxmox container.

## Deploying Demo Container

  1. Download bitnami wordpress 64bit installer for linux https://bitnami.com/stack/wordpress/installer and place into src/.
  2. `cd demo`
  3. `cp terraform.tfvars.example terraform.tfvars`
  4. Update variables in `terraform.tfvars` for your environment.
  5. Initialize terraform: `terraform init`
  5. Verify you planned deployment: `terraform plan -var-file="terraform.tfvars"`
  6. Finally deploy: `terraform apply -var-file="terraform.tfvars"`

To deploy a second container simply copy the demo directory and content to another directory and update `terraform.tfvars` to reflect the new desired deployment.  Make not to copy `.terraform` and `*.tfstate*` files or remove after copy.  Then simply follow steps 3-6 inside the new directory to deploy.

Example:

```
cp -rp demo myblog
rm -rf myblog/.terraform
rm myblog/*.tfstate*`
```

## Example terraform.tfvars

```
container_name     = "demo"
container_vmid     = "200"
container_password = "password-to-set"
container_ip       = "192.168.1.10"
container_gw       = "192.168.1.1"
container_ns       = "192.168.1.1"
phpmyadmin_require = "ip 192.168.1.0\\/24" # set to your ip or subnet escape / required; default is local"
ostemplate         = "tank:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
bitnami_installer  = "bitnami-wordpress-5.9.3-0-linux-x64-installer.run"

proxmox_host    = "proxy"
pm_api_url      = "https://192.168.1.20:8006/api2/json"
pm_user         = "root@pam"
pm_password     = "pmrootpass"
pm_tls_insecure = "true"
```


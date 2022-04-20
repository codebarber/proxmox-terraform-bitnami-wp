# terraform-proxmox-bitnami-wp

This terraform code will spin up a proxmox container and deploy bitnami wordpress all configured with updated default plugins.  This is a quick hack to deploy wordpress development sites to my home lab using bitnami wordpress, I've seen bitnami wordpress used many places that is why I'm starting with bitnami.  Instead of creating a single terraform, it is modularized to share components, which will allow creating alternate versions of wordpress deployments.  The current state is alpha, but works for what I use it for.  If you have questions/issues, feel free to create an issue.

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
container_password = "password"
container_ip       = "192.168.1.10"
container_gw       = "192.168.1.1"
container_ns       = "192.168.1.1"
rootfs_storage     = "local-lvm"
rootfs_size        = "8G"
phpmyadmin_require = "ip 192.168.1.0\\/24" # set to your ip or subnet escape / required; default is local"
ostemplate         = "tank:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
bitnami_installer  = "bitnami-wordpress-5.9.3-0-linux-x64-installer.run"

wp_name            = "Demo Blog"
wp_site_url        = "localhost"
wp_user            = "bitnami"
wp_user_pass       = "password"
wp_user_email      = "name@domain.tld"

proxmox_host    = "proxy"
pm_api_url      = "https://192.168.1.20:8006/api2/json"
pm_user         = "root@pam"
pm_password     = "pmrootpass"
pm_tls_insecure = "true"
```


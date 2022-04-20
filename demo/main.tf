# Demo Proxnami Site
# Proxnami provisions a proxmox container with bitnami wordpress deployed

module "proxnami" {
  source = "../modules/proxnami"

  proxmox_host   = var.proxmox_host
  container_name = var.container_name
  ostemplate     = var.ostemplate
  container_vmid = var.container_vmid
  container_ip   = var.container_ip
  container_gw   = var.container_gw
  container_ns   = var.container_ns

  rootfs_storage = var.rootfs_storage
  rootfs_size    = var.rootfs_size

  container_password   = var.container_password
  
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = var.pm_tls_insecure

  bitnami_installer  = var.bitnami_installer

  phpmyadmin_require = var.phpmyadmin_require
  wp_user            = var.wp_user
  wp_user_pass       = var.wp_user_pass
  wp_user_email      = var.wp_user_email
  wp_site_url        = var.wp_site_url
  wp_name            = var.wp_name
}

output "container_name" {
  value = var.container_name
}

output "container_vmid" {
  value = var.container_vmid
}
output "container_ip" {
  value = var.container_ip
}

output "wordpress_url" {
  value = format("http://%s", var.container_ip)
}

output "wordpress_admin_url" {
  value = format("http://%s/wp_admin", var.container_ip)
}
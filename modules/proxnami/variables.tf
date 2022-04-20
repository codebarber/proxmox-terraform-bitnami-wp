variable "proxmox_host" {
  description = "The proxmox hostname to deploy container"
  type        = string
}

variable "container_password" {
  description = "Password for the root account on container"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_vmid" {
  description = "VMID of the proxmox container"
  type        = number
}

variable "container_ip" {
  description = "Containers IP address"
  type        = string
}

variable "container_gw" {
  description = "Gateway IP address"
  type        = string
}

variable "container_ns" {
  description = "Name Server to use"
  type        = string
}

variable "container_mem" {
  description = "Amount of memory to allocate"
  type        = string
}

variable "container_cores" {
  description = "Number of cores to allocate"
  type        = string
}

variable "ostemplate" {
  description = "The proxmox container template to use"
  type        = string
}

variable "rootfs_storage" {
  description = "The proxmox storage volume to create container on"
  type        = string
}

variable "rootfs_size" {
  description = "The size of rootfs volume"
  type        = string
  default     = "8G"
}

variable "phpmyadmin_require" {
  description = "Allow to access phpmyadmin webapp"
  type        = string
}

variable "pm_api_url" {
  description = "Proxmox provider API url"
  type        = string
}

variable "pm_user" {
  description = "Proxmox provider user"
  type        = string
}

variable "pm_password" {
  description = "Promxmox provider password"
  type        = string
}

variable "pm_tls_insecure" {
  description = "Proxmox provider using self signed certificate"
  type        = string
}

variable "bitnami_installer" {
  description = "Bitnami Installer"
  type        = string
}

variable "wp_name" {
  description = "WP user name"
  type        = string
}

variable "wp_site_url" {
  description = "WP site url"
  type        = string
}

variable "wp_user" {
  description = "Default WP username"
  type        = string
}

variable "wp_user_pass" {
  description = "Default WP user password"
  type        = string
}

variable "wp_user_email" {
  description = "Default WP user email address"
  type        = string
}

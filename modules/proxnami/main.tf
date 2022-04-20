terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.7"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = var.pm_tls_insecure
}

resource "proxmox_lxc" "container" {
    target_node  = var.proxmox_host
    vmid         = var.container_vmid
    hostname     = var.container_name
    ostemplate   = var.ostemplate
    password     = var.container_password
    unprivileged = true
    cores        = var.container_cores
    memory       = var.container_mem
    nameserver   = var.container_ns
    onboot       = true
    start        = true

    ssh_public_keys = file(pathexpand("~/.ssh/id_rsa.pub"))

    //Terraform will crash without rootfs defined
    rootfs {
        storage = var.rootfs_storage
        size    = var.rootfs_size
    }

    network {
        name    = "eth0"
        bridge  = "vmbr0"
        ip      = format("%s/24", var.container_ip)
        gw      = var.container_gw
        ip6     = "auto"
    }

    features {
        fuse    = false
        keyctl  = false
        nesting = true
    }

    provisioner "file" {
        destination = "/tmp/bitnami-options.cfg"
        content = templatefile(format("%s/templates/bitnami-options.tpl", path.module),
            {
                wp_user            = var.wp_user
                wp_user_pass       = var.wp_user_pass
                wp_user_email      = var.wp_user_email
                wp_name            = var.wp_name
                wp_site_url        = var.wp_site_url
                bitnami_installer  = var.bitnami_installer
                phpmyadmin_require = var.phpmyadmin_require
            }
         )

        connection {
            type = "ssh"
            user = "root"
            host = var.container_ip
        }
    }

    provisioner "file" {
        source = format("%s/../src/%s", path.root, var.bitnami_installer)
        destination = format("/tmp/%s", var.bitnami_installer)

        connection {
            type = "ssh"
            user = "root"
            host = var.container_ip
        }
    }
    
    provisioner "file" {
        destination = "/tmp/user-data.sh"
        content = templatefile(format("%s/templates/user-data.tpl", path.module),
            {
                bitnami_installer = var.bitnami_installer
                phpmyadmin_require = var.phpmyadmin_require
            }
         )

        connection {
            type = "ssh"
            user = "root"
            host = var.container_ip
        }
    }

    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /tmp/user-data.sh",
            "/tmp/user-data.sh"
        ]

        connection {
            type = "ssh"
            user = "root"
            host = var.container_ip
        }
    }

}


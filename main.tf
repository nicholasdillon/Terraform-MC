terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 2.0"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

resource "linode_instance" "minecraft" {
  label       = "minecraft-server"
  image       = "linode/ubuntu22.04"
  region      = var.region
  type        = var.instance_type
  root_pass   = var.root_pass

  authorized_keys = [var.ssh_key]

  stackscript_id = null

  provisioner "file" {
    source      = "startup.sh"
    destination = "/root/startup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/startup.sh",
      "/root/startup.sh"
    ]
  }

  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_pass
    host     = self.ip_address
  }
}

resource "linode_domain_record" "minecraft_dns" {
  domain_id  = var.domain_id
  name       = "mc"
  record_type = "A"
  target     = linode_instance.minecraft.ip_address
  ttl_sec    = 300
}

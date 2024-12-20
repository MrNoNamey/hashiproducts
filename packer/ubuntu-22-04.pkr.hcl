packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.5"
      source = "github.com/hashicorp/virtualbox"
    }
    vagrant = {
      version = ">= 1.1.2"
      source = "github.com/hashicorp/vagrant"
    }
  }
}

# Variable Definitions
variable "ssh_username" {
  type = string
}

variable "ssh_password" {
  type = string
  sensitive = true # true --> wird in der Ausgabe nicht angezeigt
}

source "virtualbox-iso" "ubuntu-server" {
  guest_os_type = "Ubuntu22_LTS_64"
  
  iso_url = "http://releases.ubuntu.com/22.04.2/ubuntu-22.04.2-live-server-amd64.iso"
  iso_checksum = "SHA256:5e38b55d57d94ff029719342357325ed3bda38fa80054f9330dc789cd2d43931"

  memory = 2048
  http_directory = "http"
  
  boot_command = [
    "<esc><wait>",
    "<esc><wait>",
    "<enter><wait>",
    "/install/vmlinuz<wait>",
    " initrd=/install/initrd.gz",
    " auto-install/enable=true",
    " debconf/priority=critical",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
    " -- <wait>",
    "<enter><wait>"
  ]

  boot_wait = "30s"  # Increased wait time
  ssh_username = "vagrant"  # Ensure the default 'vagrant' username is correct
  ssh_password = "vagrant"  # Ensure the password is also correct
  ssh_wait_timeout = "10m"  # Reduced timeout for testing purposes
  
  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
}

build {
  name = "vagrant"
  sources = [
    "sources.virtualbox-iso.ubuntu-server"
  ]
  
  post-processors {
    post-processor "vagrant" {
      keep_input_artifact = true
      output = "ubuntu-server-22-04.box"
      provider_override = "virtualbox"
    }
  }
}

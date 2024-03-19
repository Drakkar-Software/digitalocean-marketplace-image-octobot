# Image vars

variable "application_name" {
  type    = string
  default = "octobot"
}

variable "application_version" {
  type    = string
  default ="1.0.8"
}

variable "image_name" {
  type = string
  default = "octobot-1.0.8-ubuntu-22-04"
}

variable "apt_packages" {
  type    = string
  default = "git build-essential curl ca-certificates fail2ban"
}

# Build vars

variable "vm_name" {
  type    = string
  default = "packer-jammy"
}

variable "ssh_username" {
  type    = string
  default = "user"
}

variable "ssh_password" {
  type       = string
  default    = "password"
  sensitive  = true
}

variable "ova_source_path" {
  type    = string
  default = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.ova"
}

# Virtual Machine vars

variable "headless" {
  type    = bool
  default = true
}

variable "vm_cpu_cores" {
  type    = number
  default = 2
}

variable "vm_mem_size" {
  type    = number
  default = 2048
}

source "virtualbox-ovf" "jammy" {
  vm_name         = var.vm_name
  source_path     = var.ova_source_path
  headless        = var.headless
  ssh_password    = var.ssh_password
  ssh_username    = var.ssh_username
  ssh_port        = 22
  ssh_timeout     = "30m"
  shutdown_command = "sudo -S -E shutdown -P now"
  shutdown_timeout = "5m"
  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--cpus", var.vm_cpu_cores],
    ["modifyvm", "{{ .Name }}", "--memory", var.vm_mem_size],
  ]
}

build {
  sources = ["source.virtualbox-ovf.jammy"]

provisioner "shell" {
  name              = "cloud-init status"
  inline            = ["cloud-init status --wait"]
}

provisioner "shell" {
  name              = "cleanup motd"
  inline            = ["rm -f /etc/update-motd.d/*"]
}

provisioner "file" {
  name        = "copy etc files"
  source      = "files/etc/"
  destination = "/etc/"
}

provisioner "file" {
  name        = "copy var files"
  source      = "files/var/"
  destination = "/var/"
}

provisioner "shell" {
  name              = "update and upgrade packages"
  environment_vars  = [
    "DEBIAN_FRONTEND=noninteractive",
    "LC_ALL=C",
    "LANG=en_US.UTF-8",
    "LC_CTYPE=en_US.UTF-8"
  ]
  inline = [
    "apt -qqy update",
    "apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' full-upgrade",
    "apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install ${var.apt_packages}",
    "apt-get -qqy clean"
  ]
}

provisioner "shell" {
  name              = "run scripts"
  environment_vars  = [
    "application_name=${var.application_name}",
    "application_version=${var.application_version}",
    "DEBIAN_FRONTEND=noninteractive",
    "LC_ALL=C",
    "LANG=en_US.UTF-8",
    "LC_CTYPE=en_US.UTF-8"
  ]
  inline = [
    "scripts/01-octobot.sh",
    "scripts/02-security.sh",
    "scripts/90-cleanup.sh",
    "scripts/99-img-check.sh"
  ]

  }
}
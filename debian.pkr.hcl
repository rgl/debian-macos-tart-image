packer {
  required_plugins {
    # see https://github.com/cirruslabs/packer-plugin-tart
    tart = {
      version = ">= 1.3.1"
      source  = "github.com/cirruslabs/tart"
    }
  }
}

variable "image" {
  type    = string
  default = "debian-12"
}

variable "iso_path" {
  type    = string
  default = "tmp/debian-12.0.0-arm64-netinst.iso"
}

variable "preseed_iso_path" {
  type    = string
  default = "tmp/preseed.iso"
}

source "tart-cli" "debian" {
  from_iso     = [var.iso_path, var.preseed_iso_path]
  vm_name      = var.image
  cpu_count    = 4
  memory_gb    = 2
  headless     = false
  ssh_password = "admin"
  ssh_username = "admin"
  ssh_timeout  = "120s"
  boot_command = [
    // wait for grub to load.
    "<wait5s>",
    // start the installation.
    "c",
    "linux /install.a64/vmlinuz",
    " auto=true",
    " url=/media/preseed.txt",
    " hostname=debian",
    " domain=home",
    " net.ifnames=0",
    " BOOT_DEBUG=2",
    " DEBCONF_DEBUG=5",
    "<enter>",
    "initrd /install.a64/initrd.gz<enter>",
    "boot<enter>",
    "<wait2m>",
    // switch to the second virtual console.
    // TODO test the boot commands from here on, once https://github.com/cirruslabs/packer-plugin-tart/issues/71 is fixed.
    "<leftAltOn><f2><leftAltOff><wait>",
    // // activate the console.
    // "<enter><wait>",
    // // mount the preseed iso.
    // "mount /dev/vdc /media<enter>",
    // switch to the first virtual console.
    // "<leftAltOn><f1><leftAltOff><wait>",
    // close the expected Failed to retrieve the preconfiguration file.
    // "<enter><wait>",
    // proceed with the auto installation.
    // TODO
  ]
}

build {
  sources = ["source.tart-cli.debian"]
}

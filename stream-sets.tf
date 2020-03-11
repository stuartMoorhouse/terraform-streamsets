variable "admin_password" {
  type = string
}

resource "digitalocean_droplet" "streamsets" {
    image = "docker-18-04"
    name = "streamsets"
    region = "lon1"
    size = "s-2vcpu-4gb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

  connection {
      host = "${digitalocean_droplet.streamsets.ipv4_address}"
      user = "root"
      type = "ssh"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      # pull the StreamSets image from DockerHub and run it
      "docker volume create --name sdc-data",
      "docker pull streamsets/datacollector",
      "docker run --restart on-failure -p 18630:18630 -d -v sdc-data:/data --name streamsets-dc streamsets/datacollector dc",
    
      # change the Admin user's password, by creating a hash of the value of ${var.admin_password} and replacing the hash of the default Admin password (found in /etc/sdc/form-realm.properties) with it
     " docker exec -it streamsets-dc /bin/bash -c 'password=$(echo -n ${var.admin_password} | sudo md5sum | cut -d\" \" -f1) && sed -i \"s/admin.*/admin:   MD5:$password,user,admin/\" /etc/sdc/form-realm.properties' ",
     "docker restart streamsets-dc"
    ]
  }

}

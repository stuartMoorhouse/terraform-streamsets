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
      # run StreamSets from a Docker image
      "docker volume create --name sdc-data",
      "docker pull streamsets/datacollector",
      "docker run --restart on-failure -p 18630:18630 -d -v sdc-data:/data --name streamsets-dc streamsets/datacollector dc",
    
      # TO DO: change the admin user's default password
     # " docker exec -it streamsets-dc /bin/bash -c \"password=$(echo -n PASSWORD | sudo md5sum | cut -d' ' -f1) && sed -i \"s/admin.*/admin:   MD5:$password,user,admin/\" /etc/sdc/form-realm.properties\" ",
     # "docker restart streamsets-dc"
    ]
  }

}

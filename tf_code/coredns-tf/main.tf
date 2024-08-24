provider "google" {
  project = "dane-dnssec-poc"
  region  = "europe-southwest1"
}

resource "google_compute_instance" "coredns" {
  name         = "coredns-instance"
  machine_type = "e2-small"
  zone         = "europe-southwest1-a"

  boot_disk {
    initialize_params {
      image = "projects/dane-dnssec-poc/global/images/coredns-v2"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata_startup_script = <<EOF
    cd /app
    sudo /app/coredns/coredns -dns.port=1053 -conf /app/coredns-config/coredns.conf & 

    sudo python3 -m venv /app/coredns-api/venv
    sudo /app/coredns-api/venv/bin/pip3 install -r /app/coredns-api/requirements.txt

    sudo /app/coredns-api/venv/bin/python3 /app/coredns-api/api.py &

    sudo apt update && sudo apt install htop

  EOF

}

output "coredns_instance_ip" {
  value = google_compute_instance.coredns.network_interface[0].access_config[0].nat_ip
}

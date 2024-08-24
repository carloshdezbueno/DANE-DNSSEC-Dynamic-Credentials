provider "google" {
  project = "dane-dnssec-poc"
  region  = "europe-southwest1"
}

provider "random" {
  # Random provider configuration (if needed)
}

data "google_compute_instance" "coredns_instance" {

  project = "dane-dnssec-poc"
  zone    = "europe-southwest1-a"
  name    = "coredns-instance"
}

resource "random_id" "my_random_id" {
  count       = 36
  byte_length = 16

  keepers = {
    # Generate a new id based on the index and timestamp
    machine = "${count.index}-${timestamp()}"  
  }
}


resource "google_compute_instance" "ephemeral_worker" {

  count        = 6
  name         = "ephemeral-instance-${random_id.my_random_id[count.index].hex}"
  machine_type = "e2-small"
  zone         = "europe-southwest1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata_startup_script = <<EOF
    #!/bin/bash

    export DOMAIN="hogehoge.hoge"
    export RECORD_NAME="${random_id.my_random_id[count.index].hex}"

    sudo mkdir /cacert

    sudo openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out /cacert/MyCertificate.crt -keyout /cacert/MyKey.key \
    -subj "/C=ES/ST=MA/L=MA/O=UC3M/OU=IT/CN=$DOMAIN/emailAddress=admin@$DOMAIN"

    sha256_checksum=$(sha256sum /cacert/MyCertificate.crt | awk '{print $1}')

    # Set environment variables
    export IP_ADDRESS=$(curl -s ifconfig.me)
    export TLSA_DATA="3 1 1 $sha256_checksum"
    export URL="http://${data.google_compute_instance.coredns_instance.network_interface[0].access_config[0].nat_ip}:5000"

    # Run curl command
    curl -X POST \
    -H "Content-Type: application/json" \
    -d '{
        "domain": "'"$DOMAIN"'",
        "record_name": "'"$RECORD_NAME"'",
        "ip_address": "'"$IP_ADDRESS"'",
        "tlsa_data": "'"$TLSA_DATA"'"
    }' \
    "$URL/add_record"

    sleep ${count.index * 10}

    curl -X DELETE $URL/delete_record/$RECORD_NAME

    sudo shutdown -h now

  EOF
}

resource "google_compute_instance" "ephemeral_worker_2" {

  count        = 6
  name         = "ephemeral-instance-${random_id.my_random_id[6+count.index].hex}"
  machine_type = "e2-small"
  zone         = "europe-central2-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata_startup_script = <<EOF
    #!/bin/bash

    export DOMAIN="hogehoge.hoge"
    export RECORD_NAME="${random_id.my_random_id[6+count.index].hex}"

    sudo mkdir /cacert

    sudo openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out /cacert/MyCertificate.crt -keyout /cacert/MyKey.key \
    -subj "/C=ES/ST=MA/L=MA/O=UC3M/OU=IT/CN=$DOMAIN/emailAddress=admin@$DOMAIN"

    sha256_checksum=$(sha256sum /cacert/MyCertificate.crt | awk '{print $1}')

    # Set environment variables
    export IP_ADDRESS=$(curl -s ifconfig.me)
    export TLSA_DATA="3 1 1 $sha256_checksum"
    export URL="http://${data.google_compute_instance.coredns_instance.network_interface[0].access_config[0].nat_ip}:5000"

    # Run curl command
    curl -X POST \
    -H "Content-Type: application/json" \
    -d '{
        "domain": "'"$DOMAIN"'",
        "record_name": "'"$RECORD_NAME"'",
        "ip_address": "'"$IP_ADDRESS"'",
        "tlsa_data": "'"$TLSA_DATA"'"
    }' \
    "$URL/add_record"

    sleep ${6+count.index * 10}

    curl -X DELETE $URL/delete_record/$RECORD_NAME

    sudo shutdown -h now

  EOF
}

resource "google_compute_instance" "ephemeral_worker_3" {

  count        = 6
  name         = "ephemeral-instance-${random_id.my_random_id[12+count.index].hex}"
  machine_type = "e2-small"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata_startup_script = <<EOF
    #!/bin/bash

    export DOMAIN="hogehoge.hoge"
    export RECORD_NAME="${random_id.my_random_id[12+count.index].hex}"

    sudo mkdir /cacert

    sudo openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out /cacert/MyCertificate.crt -keyout /cacert/MyKey.key \
    -subj "/C=ES/ST=MA/L=MA/O=UC3M/OU=IT/CN=$DOMAIN/emailAddress=admin@$DOMAIN"

    sha256_checksum=$(sha256sum /cacert/MyCertificate.crt | awk '{print $1}')

    # Set environment variables
    export IP_ADDRESS=$(curl -s ifconfig.me)
    export TLSA_DATA="3 1 1 $sha256_checksum"
    export URL="http://${data.google_compute_instance.coredns_instance.network_interface[0].access_config[0].nat_ip}:5000"

    # Run curl command
    curl -X POST \
    -H "Content-Type: application/json" \
    -d '{
        "domain": "'"$DOMAIN"'",
        "record_name": "'"$RECORD_NAME"'",
        "ip_address": "'"$IP_ADDRESS"'",
        "tlsa_data": "'"$TLSA_DATA"'"
    }' \
    "$URL/add_record"

    sleep ${12+count.index * 10}

    curl -X DELETE $URL/delete_record/$RECORD_NAME

    sudo shutdown -h now

  EOF
}

resource "google_compute_instance" "ephemeral_worker_4" {

  count        = 6
  name         = "ephemeral-instance-${random_id.my_random_id[18+count.index].hex}"
  machine_type = "e2-small"
  zone         = "us-south1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata_startup_script = <<EOF
    #!/bin/bash

    export DOMAIN="hogehoge.hoge"
    export RECORD_NAME="${random_id.my_random_id[18+count.index].hex}"

    sudo mkdir /cacert

    sudo openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out /cacert/MyCertificate.crt -keyout /cacert/MyKey.key \
    -subj "/C=ES/ST=MA/L=MA/O=UC3M/OU=IT/CN=$DOMAIN/emailAddress=admin@$DOMAIN"

    sha256_checksum=$(sha256sum /cacert/MyCertificate.crt | awk '{print $1}')

    # Set environment variables
    export IP_ADDRESS=$(curl -s ifconfig.me)
    export TLSA_DATA="3 1 1 $sha256_checksum"
    export URL="http://${data.google_compute_instance.coredns_instance.network_interface[0].access_config[0].nat_ip}:5000"

    # Run curl command
    curl -X POST \
    -H "Content-Type: application/json" \
    -d '{
        "domain": "'"$DOMAIN"'",
        "record_name": "'"$RECORD_NAME"'",
        "ip_address": "'"$IP_ADDRESS"'",
        "tlsa_data": "'"$TLSA_DATA"'"
    }' \
    "$URL/add_record"

    sleep ${18+count.index * 10}

    curl -X DELETE $URL/delete_record/$RECORD_NAME

    sudo shutdown -h now

  EOF
}

output "random_id_value" {
  value = [
    for index in range(length(random_id.my_random_id)): {
      index = index
      value = random_id.my_random_id[index].hex
    }
  ]
}

resource "google_compute_instance" "ephemeral_worker_5" {

  count        = 6
  name         = "ephemeral-instance-${random_id.my_random_id[24+count.index].hex}"
  machine_type = "e2-small"
  zone         = "europe-west2-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata_startup_script = <<EOF
    #!/bin/bash

    export DOMAIN="hogehoge.hoge"
    export RECORD_NAME="${random_id.my_random_id[24+count.index].hex}"

    sudo mkdir /cacert

    sudo openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out /cacert/MyCertificate.crt -keyout /cacert/MyKey.key \
    -subj "/C=ES/ST=MA/L=MA/O=UC3M/OU=IT/CN=$DOMAIN/emailAddress=admin@$DOMAIN"

    sha256_checksum=$(sha256sum /cacert/MyCertificate.crt | awk '{print $1}')

    # Set environment variables
    export IP_ADDRESS=$(curl -s ifconfig.me)
    export TLSA_DATA="3 1 1 $sha256_checksum"
    export URL="http://${data.google_compute_instance.coredns_instance.network_interface[0].access_config[0].nat_ip}:5000"

    # Run curl command
    curl -X POST \
    -H "Content-Type: application/json" \
    -d '{
        "domain": "'"$DOMAIN"'",
        "record_name": "'"$RECORD_NAME"'",
        "ip_address": "'"$IP_ADDRESS"'",
        "tlsa_data": "'"$TLSA_DATA"'"
    }' \
    "$URL/add_record"

    sleep ${count.index * 10}

    curl -X DELETE $URL/delete_record/$RECORD_NAME

    sudo shutdown -h now

  EOF
}
#!/bin/bash

# Update dan instal dependencies yang dibutuhkan
echo "Menambahkan GPG key Docker dan memperbarui repository..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl jq

# Install keyring Docker
echo "Menginstal GPG key Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Menambahkan repository Docker ke Apt sources
echo "Menambahkan repository Docker ke sources list..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker dan dependensinya
echo "Menginstal Docker..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Membuat grup Docker dan menambahkan user ke grup Docker
echo "Membuat grup Docker dan menambahkan user ke dalam grup..."
sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock

# Menginstal Docker Compose versi terbaru
echo "Menginstal Docker Compose..."
VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
DESTINATION=/usr/bin/docker-compose
sudo curl -sL https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
sudo chmod 755 $DESTINATION

# Membuat direktori untuk WordPress dan Docker Compose file
echo "Membuat direktori untuk WordPress dan konfigurasi Docker Compose..."
cd $HOME
mkdir -p latihan/my_wordpress
cd latihan/my_wordpress

# Menjalankan Docker Compose untuk WordPress (gunakan file docker-compose.yml yang sudah ada)
echo "Menjalankan Docker Compose untuk WordPress..."
sudo docker compose up -d

echo "Proses instalasi dan setup selesai!"

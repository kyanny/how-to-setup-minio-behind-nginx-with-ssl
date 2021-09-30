#!/bin/bash
set -e

MINIO_ROOT_USER=admin
MINIO_ROOT_PASSWORD=password
MINIO_VOLUMES=/mnt/data

wget -nc https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio
sudo cp minio /usr/local/bin

wget -nc https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
sudo cp mc /usr/local/bin

sudo mkdir -p $MINIO_VOLUMES
sudo chmod -R 0777 $MINIO_VOLUMES

# https://github.com/minio/minio-service
sudo useradd -s /sbin/nologin -M -U minio-user
sudo mkdir -p /etc/default
cat <<EOT | sudo tee -a /etc/default/minio
# Volume to be used for MinIO server.
MINIO_VOLUMES="$MINIO_VOLUMES"
# Use if you want to run MinIO on a custom port.
MINIO_OPTS="--address 127.0.0.1:9000 --console-address 127.0.0.1:9001"
# Root user for the server.
MINIO_ROOT_USER=$MINIO_ROOT_USER
# Root secret for the server.
MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD

EOT
wget -nc https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/minio.service
sudo cp minio.service /etc/systemd/system/
sudo systemctl enable minio.service
sudo systemctl start minio.service
sudo systemctl status minio.service

echo "Or start MinIO server"
echo ""
echo "  MINIO_ROOT_USER=admin MINIO_ROOT_PASSWORD=password /usr/local/bin/minio server /mnt/data --console-address ':9001' &"

sleep 5

mc alias set my1 http://127.0.0.1:9000/ admin password
mc alias set my2 https://127.0.0.1/ admin password
mc alias set my3 https://example.local/ admin password
mc alias set my4 https://my.example.local/ admin password

mc mb my4/test
mc cp minio.service my4/test/minio.service
mc ls my4/
mc ls my4/test/
mc --debug ls my4/test

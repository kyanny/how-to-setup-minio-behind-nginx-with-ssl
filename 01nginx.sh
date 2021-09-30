#!/bin/bash
set -xe

sudo apt install nginx -y
sudo systemctl start nginx
curl -v localhost

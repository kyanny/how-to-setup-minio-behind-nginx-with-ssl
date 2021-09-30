#!/bin/bash
set -xe

echo '127.0.0.1 example.local' | sudo tee -a /etc/hosts
echo '127.0.0.1 my.example.local' | sudo tee -a /etc/hosts

# https://ma38su.hatenablog.com/entry/2020/06/27/235451
# https://kazuhira-r.hatenablog.com/entry/20180803/1533302929
# SAN
# *.example.local
# 127.0.0.1
echo "subjectAltName = DNS:*.example.local, DNS:example.local, IP:127.0.0.1" > san.txt
openssl genrsa -out sample.key 2048
openssl req -new -key sample.key -out sample.csr -subj "/CN=*.example.com"
openssl x509 -req -days 365 -in sample.csr -signkey sample.key -out sample.crt -extfile san.txt

# check
openssl x509 -text -in sample.crt --noout

sudo cp sample.crt /etc/nginx
sudo cp sample.key /etc/nginx

cat <<'EOM' > proxy.conf

server {
    listen       443 ssl;

    ssl_certificate      /etc/nginx/sample.crt;
    ssl_certificate_key  /etc/nginx/sample.key;

    location / {
        proxy_pass http://127.0.0.1:9000;
        proxy_redirect                          off;
        proxy_set_header Host                   $host;
        proxy_set_header X-Real-IP              $remote_addr;
        proxy_set_header X-Forwarded-Host       $host;
        proxy_set_header X-Forwarded-Server     $host;
        proxy_set_header X-Forwarded-Proto      $scheme;
        proxy_set_header X-Forwarded-For        $proxy_add_x_forwarded_for;
    }
}
EOM

sudo cp proxy.conf /etc/nginx/sites-available/proxy.conf
sudo ln -s /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/proxy.conf || :

sudo systemctl restart nginx

sudo cp sample.crt /etc/ssl/certs/sample.crt
sudo update-ca-certificates

curl --cacert /etc/ssl/certs/sample.crt -v https://127.0.0.1/
curl --cacert /etc/ssl/certs/sample.crt -v https://example.local/
curl --cacert /etc/ssl/certs/sample.crt -v https://my.example.local/

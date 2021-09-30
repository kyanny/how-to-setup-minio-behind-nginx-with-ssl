# How to setup MinIO server behind nginx with SSL/TLS (self-signed certificate)

Collection of the scripts to setup MinIO and nginx SSL/TLS with a self-signed certificate.

The purpose is that being able to reproduce this setup easily.

Suppose these shell scripts are used in Ubuntu Linux.

Simply use Vagrant.

```
vagrant up

vagrant ssh
curl --cacert /etc/ssl/certs/sample.crt https://example.local
```

Or donwload the repo and run scripts respectively.

```
git clone https://github.com/kyanny/how-to-setup-minio-behind-nginx-with-ssl scripts
cd scripts/
ls *.sh | xargs -I {} bash {}
```

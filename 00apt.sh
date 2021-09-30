#!/bin/bash
set -xe

sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

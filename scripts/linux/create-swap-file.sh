#!/usr/bin/env bash
# run as superuser...

mkdir -v /var/cache/swap && cd /var/cache/swap/

# 4Gb swap file
dd if=/dev/zero of=swapfile bs=1K count=4M && chmod 600 swapfile

mkswap swapfile && swapon swapfile

echo "/var/cache/swap/swapfile none swap sw 0 0" | tee -a /etc/fstab

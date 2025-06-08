#!/bin/bash

if ! command -v helmfile 2>&1 >/dev/null
then
  helmfile_version="1.1.0"
  wget https://github.com/helmfile/helmfile/releases/download/v"$helmfile_version"/helmfile_"$helmfile_version"_linux_amd64.tar.gz
  tar -xxf helmfile_"$helmfile_version"_linux_amd64.tar.gz
  rm helmfile_"$helmfile_version"_linux_amd64.tar.gz
  mv helmfile /usr/local/bin/
  helmfile init --force
fi

cfssl_version=1.6.5
if ! command -v cfssl 2>&1 >/dev/null
then
  wget https://github.com/cloudflare/cfssl/releases/download/v"$cfssl_version"/cfssl_"$cfssl_version"_linux_amd64
  mv cfssl_"$cfssl_version"_linux_amd64 /usr/local/bin/cfssl
  chmod +x /usr/local/bin/cfssl
fi

if ! command -v cfssljson 2>&1 >/dev/null
then
  wget https://github.com/cloudflare/cfssl/releases/download/v"$cfssl_version"/cfssljson_"$cfssl_version"_linux_amd64
  mv cfssljson_"$cfssl_version"_linux_amd64 /usr/local/bin/cfssljson
  chmod +x /usr/local/bin/cfssljson
fi

#!/usr/bin/env bash

set -eu -o pipefail

if ! which git ; then
	apt-get update
	apt-get install -y git
fi

if ! which curl ; then
	apt-get update
	apt-get install -y curl
fi

WORKDIR="$(mktemp -d)"

cd "$WORKDIR"
# Install docker
curl https://raw.githubusercontent.com/bastiandg/setup/master/packages/docker.sh -O docker.sh
bash docker.sh

# Install docker-nextcloud
DOMAIN_NAME="$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/domain" -H "Metadata-Flavor: Google")"
EMAIL="$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/mail" -H "Metadata-Flavor: Google")"
git clone https://github.com/bastiandg/docker-nextcloud.git
cd docker-nextcloud
chmod +x install.sh
./install.sh "$DOMAIN_NAME" "$EMAIL" "/var/data/nextcloud"

cd "$HOME"
rm -rf "$WORKDIR"

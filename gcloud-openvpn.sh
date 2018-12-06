#!/usr/bin/env bash

set -eu -o pipefail

if ! which curl ; then
	apt-get update
	apt-get install -y curl
fi

OVPN_DATA="/var/docker/openvpn"
CERT_LOCATION="/var/vpn/client_configs"
# Install docker
curl https://raw.githubusercontent.com/bastiandg/setup/master/packages/docker.sh -O docker.sh
bash docker.sh

mkdir -p "$OVPN_DATA"
# initialize vpn
DOMAIN_NAME="$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/domain" -H "Metadata-Flavor: Google")"
docker run -v "$OVPN_DATA:/etc/openvpn" --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u "udp://$DOMAIN_NAME"
docker run -v "$OVPN_DATA:/etc/openvpn" --log-driver=none --rm -it kylemanna/openvpn sh -c "echo | ovpn_initpki nopass"

# start vpn container in a daemon like way
docker run -v "$OVPN_DATA:/etc/openvpn" --restart=unless-stopped -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn

mkdir -p "$CERT_LOCATION"
# create first client config
docker run -v "$OVPN_DATA:/etc/openvpn" --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full "client1" nopass
docker run -v "$OVPN_DATA:/etc/openvpn" --log-driver=none --rm kylemanna/openvpn ovpn_getclient client1 > "$CERT_LOCATION/client1.ovpn"

# create second client config
docker run -v "$OVPN_DATA:/etc/openvpn" --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full "client2" nopass
docker run -v "$OVPN_DATA:/etc/openvpn" --log-driver=none --rm kylemanna/openvpn ovpn_getclient client2 > "$CERT_LOCATION/client2.ovpn"

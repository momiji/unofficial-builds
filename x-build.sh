#!/bin/bash
set -Eeuo pipefail
cd "$(dirname "$0")"

version="${1:-}"

# prepare folders
cd ..

FOLDERS="download logs staging .ccache"
mkdir -p $FOLDERS

chmod 2770 $FOLDERS
chown 0:1000 $FOLDERS

# replace docker by podman and inject certificates for alpine and centos
docker() {
    action=$1
    [ "$action" = "system" ] && return 0
    shift
    podman $action --network host \
        -v /etc/pki/tls/cert.pem:/etc/ssl/cert.pem:ro \
        -v /etc/pki/tls/cert.pem:/etc/pki/tls/cert.pem \
        "$@"
}
export -f docker

# call script
umask 0007
./unofficial-builds/bin/build.sh "$version"

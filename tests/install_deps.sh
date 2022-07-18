#!/bin/bash

DISTRO="$1"
extra_args=""

packages=(
          "iotop"
          "elinks"
          "make"
          "sysstat"
          )

case ${DISTRO} in
  centos*|fedora*)
    packages+=(
               "procps-ng"
               "psmisc"
               "iproute"
    )
    dnf install --assumeyes ${packages[@]} || exit $?
    ;;
    ;;
  debian*|ubuntu*)
    packages+=(
               "gawk"
               "procps"
               "psmisc"
               "iproute2"
    )
    apt-get update
    apt-get install ${packages[@]} -y || exit $?
    ;;
  *)
    echo "Unknown distro: ${DISTRO}"
    exit 1
    ;;
esac

#!/bin/bash

DISTRO="$1"
extra_args=""

packages=(
          "iotop"
          "elinks"
          "make"
          "psmisc"
          "sysstat"
          )

case ${DISTRO} in
  fedora*)
    packages+=(
               "procps-ng"
               "iproute"
    )
    dnf install --assumeyes ${packages[@]} || exit $?
    ;;
  centos*)
    packages+=(
               "iproute"
    )
    if [[ ${DISTRO/*:/} -ge 8 ]]; then
      extra_args+="--enablerepo=PowerTools "
    fi
    yum install --assumeyes ${extra_args} ${packages[@]} || exit $?
    ;;
  debian*|ubuntu*)
    packages+=(
               "gawk"
               "procps"
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

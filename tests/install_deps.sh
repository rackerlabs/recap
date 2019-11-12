#!/bin/bash

DISTRO="$1"

packages=(
          "bash"
          "coreutils"
          "gawk"
          "grep"
          "iotop"
          "elinks"
          "make"
          "procps"
          "psmisc"
          "sysstat"
          )

case ${DISTRO} in
  fedora*)
    packages+=("iproute")
    yum install ${packages[@]} -y || exit $?
    ;;
  centos*)
    packages+=("iproute")
    if [[ ${DISTRO/*:/} -ge 8 ]]; then
      dnf --assumeyes \
        --enablerepo=PowerTools \
        install ${packages[@]} ||
      exit $?
    else
      yum install ${packages[@]} -y || exit $?
    fi
    ;;
  debian*|ubuntu*)
    packages+=("iproute2")
    apt-get update
    apt-get install ${packages[@]} -y || exit $?
    ;;
  *)
    echo "Unknown distro: ${DISTRO}"
    exit 1
    ;;
esac

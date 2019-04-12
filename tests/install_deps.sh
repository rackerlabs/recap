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
  centos*|fedora*)
    packages+=("iproute")
    yum install ${packages[@]} -y || exit $?
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

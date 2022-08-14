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
  fedora*)
    packages+=(
               "procps-ng"
               "psmisc"
               "iproute"
    )
    dnf install --assumeyes ${packages[@]} || exit $?
    ;;
  centos*)
    packages+=(
               "procps-ng"
               "psmisc"
               "iproute"
    )
    version=$(grep -Po "[0-9]+" <<<${DISTRO/*_/})
    if [[ ${version} -ge 8 ]]; then
      # elinks is not available in centos stream
      packages=( ${packages[@]/elinks} )
    fi
    dnf install --assumeyes ${packages[@]} || exit $?
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

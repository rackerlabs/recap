#!/bin/bash

# Switch to the bind mount to install recap
cd /recap

# Install recap
make install --debug=v

# Clean temporary files
make clean

# Verify recap is available after installation
type -p recap >/dev/null
exit $?

#!/bin/bash

# Get full path to recap
recap_path=$(type -p recap)

# Insert 'set -e' on line 2 of recap to exit after any failure
sed -i "2iset -e" ${recap_path};

# Save debugging info and record the status of the recap run
debug_info=$(bash -x ${recap_path} 2>&1)
stat=$?

# Save the debugging info that occurred right before the cleanup operation
cleanup_trigger=$(echo "${debug_info}" | grep -P "^\+\s+cleanup" -B 20)

# Show the info that triggered the cleanup if there was an error running recap
[ ${stat} -ne 0 ] && {
  echo "An error occurred while doing the following:"
  echo "${cleanup_trigger}"
}

# Exit with the status of the recap run
exit ${stat}

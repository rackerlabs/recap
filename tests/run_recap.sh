#!/bin/bash

# Get full path to recap
recap_path=$(type -p recap)

# Save debugging info and record the status of the recap run
# exiting on any failure
debug_info=$(bash -xe "${recap_path}" 2>&1)
stat=$?

# Save the debugging info that occurred right before the cleanup operation
cleanup_trigger=$(echo "${debug_info}" | grep -P "^\+\s+cleanup" -B 20)

# Show the info that triggered the cleanup if there was an error running recap
if [[ ${stat} -ne 0 ]]; then
  echo "An error occurred while doing the following:"
  echo "${cleanup_trigger}"
fi

# Exit with the status of the recap run
exit ${stat}

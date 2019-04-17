#!/bin/bash

# Get full path to recaplog
recaplog_path=$(type -p recaplog)

# Insert 'set -e' on line 2 of recaplog to exit after any failure
sed -i "2iset -e" "${recaplog_path}";

# Save debugging info and record the status of the recaplog run
debug_info=$(bash -x "${recaplog_path}" 2>&1)
stat=$?

# Save the debugging info that occurred right before the cleanup operation
cleanup_trigger=$(echo "${debug_info}" | grep -P "^\+\s+cleanup" -B 20)

# Show the info that triggered the cleanup if there was an error running recaplog
if [[ ${stat} -ne 0 ]]; then
  echo "An error occurred while doing the following:"
  echo "${cleanup_trigger}"
fi

# Exit with the status of the recaplog run
exit ${stat}

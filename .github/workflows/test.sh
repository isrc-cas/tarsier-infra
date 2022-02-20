#!/bin/bash
set -e

echo "Parsing user_map.json"
users="$(jq -r .userMap[][] user_map.json)"

MISSING_USERS=0
for user in ${users[@]}; do
    echo "Fetching keys for $user..."
    keys=$(curl -fsS https://github.com/$user.keys)

    echo "Checking if $user has SSH keys added..."
    if [[ -z "${keys[@]}" ]]; then
        echo "No SSH key found for $user."
	MISSING_USERS="$((MISSING_USERS + 1))"
    fi
done

echo "${MISSING_USERS}"
exit "${MISSING_USERS}"

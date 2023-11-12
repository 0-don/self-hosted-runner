#!/usr/bin/bash
export "$(grep -vE "^(#.*|\s*)$" .env)"

RUNNERS_FILE="runners.json"
CURRENT_DIR="$PWD"
count=`jq '. | length' $RUNNERS_FILE`

echo $count

for ((i=0; i < $count; i++)); do
    cd $CURRENT_DIR
    
    repo=`jq -r '.['$i'].repo' $RUNNERS_FILE`
    name=`jq -r '.['$i'].name' $RUNNERS_FILE`
    branch=`jq -r '.['$i'].branch' $RUNNERS_FILE`

    # Check if the directory exists one level above the current directory
    if [ -d "$CURRENT_DIR/../$name" ]; then 
        cd "$CURRENT_DIR/../$name"

        # Attempt to remove the service, if it fails try deleting
        curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/remove-svc.sh | bash -s $repo $name || curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/delete.sh | bash -s $repo $name

        # Remove the directory one level above
        rm -Rf "$CURRENT_DIR/../$name"
    fi
done

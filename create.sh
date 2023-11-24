#!/usr/bin/bash
export "$(grep -vE "^(#.*|\s*)$" .env)"

RUNNERS_FILE="runners.json"
CURRENT_DIR="$PWD"
count=`jq '. | length' $RUNNERS_FILE`

for ((i=0; i<$count; i++)); do
    cd $CURRENT_DIR

    repo=`jq -r '.['$i'].repo' $RUNNERS_FILE`
    name=`jq -r '.['$i'].name' $RUNNERS_FILE`
    branch=`jq -r '.['$i'].branch' $RUNNERS_FILE`
    workflow=`jq -r '.['$i'].workflow' $RUNNERS_FILE`

    # Create directories one level above the current directory
    mkdir -p "$CURRENT_DIR/../$name"
    cd "$CURRENT_DIR/../$name"

    # Modified line: Added '-f' to enable the replace flag
    curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/create-latest-svc.sh | bash -s -- -s $repo -n $name -f

    # Trigger workflow dispatch
    curl -X POST -H "Authorization: token $RUNNER_CFG_PAT" https://api.github.com/repos/$repo/actions/workflows/$workflow/dispatches -d '{"ref":"'$branch'"}'
done

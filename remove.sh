#/bin/bash
export "$(grep -vE "^(#.*|\s*)$" .env)"

RUNNERS_FILE="runners.json"
count=`jq '. | length' $RUNNERS_FILE`

for ((i=0; i<$count; i++)); do
    repo=`jq -r '.['$i'].repo' $RUNNERS_FILE`
    name=`jq -r '.['$i'].name' $RUNNERS_FILE`
    branch=`jq -r '.['$i'].branch' $RUNNERS_FILE`

    cd "$HOME/$name"

    curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/remove-svc.sh | bash -s $repo $name
    if [ -d "$HOME/$name" ]; then rm -Rf "$HOME/$name"; fi

done

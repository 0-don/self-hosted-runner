#/bin/bash
export "$(grep -vE "^(#.*|\s*)$" .env)"

[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

# sudo apt install jq -y
# clear

RUNNERS_FILE="runners.json"

count=`jq '. | length' $RUNNERS_FILE`

for ((i=0; i<$count; i++)); do
    repo=`jq -r '.['$i'].repo' $RUNNERS_FILE`
    name=`jq -r '.['$i'].name' $RUNNERS_FILE`
    branch=`jq -r '.['$i'].branch' $RUNNERS_FILE`

    mkdir `~/$name`
    cd `~/$name`

    curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/create-latest-svc.sh | bash -s -- -s $repo -n $name
done

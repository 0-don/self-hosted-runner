export "$(grep -vE "^(#.*|\s*)$" .env)"

# cashclok
curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/create-latest-svc.sh | bash -s -- -s Don-Cryptus/cashclock -n cashclock

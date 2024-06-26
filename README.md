

# Automate Configuring Self-Hosted Runners

install required packages
```bash
sudo apt install jq curl -y
```

create action runners from json
```bash
chmod +x create.sh
./create.sh
```
delete actions runners from json
```bash
chmod +x remove.sh
./remove.sh
```

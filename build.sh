#!/bin/bash

# Check if the .env file exists
if [ -f "$ENV_FILE" ]; then
    # Use 'source' or the equivalent '.' command to load the variables
    echo "Loading environment variables from $ENV_FILE..."
    source "$ENV_FILE"
else
    echo "Error: .env file not found at $ENV_FILE"
    exit 1
fi

if ! dpkg -s 'docker-compose-plugin' >/dev/null 2>&1; then
	# Add Docker's official GPG key:
	sudo apt-get update
	sudo apt-get install ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	if [ -f /etc/os-release ]; then
    	. /etc/os-release
		if [ "$ID" = "ubuntu" ]; then
			if ! dpkg -s 'yq' >/dev/null 2>&1; then
				# Install the package if not found
				sudo snap install yq
			else
				echo "yq is already installed."
			fi
			sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
			sudo chmod a+r /etc/apt/keyrings/docker.asc
			echo \
				"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
				$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
				sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		elif [ "$ID" = "debian" ]; then
			if ! dpkg -s 'yq' >/dev/null 2>&1; then
				# Install the package if not found
				sudo apt install yq
			else
				echo "yq is already installed."
			fi
			sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
			sudo chmod a+r /etc/apt/keyrings/docker.asc
			sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
		else
			echo "OS is neither Ubuntu nor Debian (ID: $ID)" >&2
			exit 1 
		fi
	else
		echo "Could not find /etc/os-release file. Cannot determine distribution." >&2
		exit 1
	fi
	sudo apt-get update
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	
	newgrp docker

else
	echo "Docker-compose already installed"
fi

if ! id -Gn | grep -qw "docker"; then
        echo "Adding group docker for $CURRENT_OS_USER"
        sudo usermod -aG docker $CURRENT_OS_USER
        newgrp docker
		echo "Please, run build.sh again as adding group to user exits the current run for build.sh"
fi

PROCESS_INFO=$(sudo ss -tulpn | grep ":53\b" | grep -oP 'users:\(\("\K[^",]+')
if [[ "$PROCESS_INFO" == "systemd-resolve" ]]; then
    echo -e "\n--- Process is identified as 'systemd-resolved'. Proceeding to disable DNS stub listener."
    sudo mkdir -p "/etc/systemd/resolved.conf.d"
    echo -e "[Resolve]\nDNSStubListener=no" | sudo tee "/etc/systemd/resolved.conf.d/dns-stub-listener-no.conf" > /dev/null
	sudo systemctl restart systemd-resolved.service
fi

array=($(yq -r '.volumes | keys[]' compose.yml))

# Create volumes
for element in "${array[@]}"; do
  docker volume create --name "$element"
done

environment=$1
if [[ $environment = "cicd" ]]; then
  cicd='-d --quiet-pull'
fi

docker compose up --build $cicd
#!/bin/bash

# Check if yq package is installed
if ! dpkg -s 'yq' >/dev/null 2>&1; then
  # Install the package if not found
  sudo snap install yq
else
  echo "yq is already installed."
fi

if ! dpkg -s 'docker-compose-plugin' >/dev/null 2>&1; then
	# Add Docker's official GPG key:
	sudo apt-get update
	sudo apt-get install ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo \
  		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  		$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
	echo "Docker-compose already installed"
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

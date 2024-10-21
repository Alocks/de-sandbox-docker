#!/bin/bash

# Check if yq package is installed
if ! dpkg -s 'yq' >/dev/null 2>&1; then
  # Install the package if not found
  sudo apt update
  sudo apt install yq
else
  echo "yq is already installed."
fi

array=($(yq -r '.volumes | keys[]' compose.yml))

# Create volumes
for element in "${array[@]}"; do
  docker volume create --name "$element"
done

docker compose up --build
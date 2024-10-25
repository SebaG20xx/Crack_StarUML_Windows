#!/bin/bash

navigate_to() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    echo -e "Directory $dir not found!\nPlease provide the correct path to the StarUML directory."
    exit 1
  fi
  cd "$dir" || { echo "Failed to navigate to $dir"; exit 1; }
  echo "[1] Navigated to $dir"
}

copy_files() {
  local source_dir="$1"
  local destination_dir="$2"
  echo "[5] Copying files from $source_dir to $destination_dir..."
  sudo cp -r "$source_dir/"* "$destination_dir/" || { echo "Failed to copy files!"; exit 1; }
}

npm_check_and_install() {
  local package_name="$1"
  echo "[2] Checking if $package_name is already installed..."
  
  if ! command -v "$package_name" &> /dev/null; then
    echo "$package_name is not installed. Installing $package_name..."
    npm install -g "$package_name" || { echo "Failed to install $package_name!"; exit 1; }
  fi
}

extract_asar() {
  echo "[3] Extracting app.asar..."
  sudo asar extract app.asar app || { echo "Failed to extract app.asar!"; exit 1; }
}

pack_asar() {
  echo "[6] Packing app.asar..."
  sudo asar pack app app.asar || { echo "Failed to pack app.asar!"; exit 1; }
}

check_version() {
  local package_json_path="$1/app/package.json"
  local expected_version="$2"
  
  if [ -f "$package_json_path" ]; then
    local version=$(grep -oP '"version": *"\K[^"]+' "$package_json_path")
    echo "[4] Checking StarUML version expected: $expected_version..."
    
    if [ "$version" != "$expected_version" ]; then
      echo "The version found in package.json is $version."
      read -p "Do you want to continue with the patch? (Y/N, default is Y): " choice
      choice=${choice:-Y}
      case "$choice" in
        [Yy]* ) echo "Continuing with the patch...";;
        [Nn]* ) echo "Exiting."; exit 1;;
        * ) echo "Invalid input. Exiting."; exit 1;;
      esac
    fi
  else
    echo "package.json not found at $package_json_path!"
    exit 1
  fi
}


script_dir=$(pwd)

if [ -n "$1" ]; then
  staruml_dir="$1"
else
  staruml_dir=$(find /opt -type d -name "StarUML" 2>/dev/null | head -n 1)
fi

if [ ! -d "$staruml_dir" ]; then
  echo -e "StarUML directory not found!\nPlease provide the valide path to the StarUML directory as an argument."
  exit 1
else
  echo -e "StarUML directory provided: $staruml_dir\n"
fi

resources_dir="$staruml_dir/resources"

navigate_to "$resources_dir"
npm_check_and_install "asar"
extract_asar

check_version "$resources_dir" "6.2.2"

copy_files "$script_dir/patch" "$resources_dir/app/src/engine"
pack_asar

echo -e "\nStarUML successfully patched!"

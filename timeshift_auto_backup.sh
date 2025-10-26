#!/bin/bash

set -e  # Exit immediately if any command fails
set -o pipefail  # Catch errors in pipelines

info() {
  echo -e "\e[34m[INFO]\e[0m $1"
}

error() {
  echo -e "\e[31m[ERROR]\e[0m $1" >&2
}

# Check if timeshift is installed
if command -v timeshift >/dev/null 2>&1; then
  info "Timeshift is already installed. Skipping installation."
else
  info "Timeshift is not installed. Updating package list and installing..."
  if ! sudo apt update; then
    error "Failed to update package list. Aborting."
    exit 1
  fi

  if ! sudo apt install timeshift -y; then
    error "Failed to install Timeshift. Aborting."
    exit 1
  fi
fi

# Verify timeshift configuration
info "Checking Timeshift configuration..."
if ! sudo timeshift --check; then
  error "Timeshift detected configuration error. Aborting."
  exit 1
fi

# Backup configuration file
info "Saving a backup of the configuration file..."
if ! sudo cp /etc/timeshift/timeshift.json /etc/timeshift/timeshift.json.bak; then
  error "Failed to backup configuration file. Aborting."
  exit 1
fi

# Modify config to exclude entire system
info "Modifying configuration to backup the entire system..."
if ! sudo sed -i '/"exclude" : \[/,/\],/c\  "exclude" : ["/"],' /etc/timeshift/timeshift.json; then
  error "Failed to modify configuration file. Aborting."
  exit 1
fi

# Create first snapshot (empty due to exclusions)
info "Creating snapshot of the entire system..."
if ! sudo timeshift --create --comments "initial system state"; then
  error "Failed to create snapshot 'initial system state'. Aborting."
  exit 1
fi

# Restore original configuration
info "Restoring original configuration file..."
if ! sudo cp /etc/timeshift/timeshift.json.bak /etc/timeshift/timeshift.json; then
  error "Failed to restore original configuration. Aborting."
  exit 1
fi

# Create second snapshot (with original config)
info "Creating snapshots while keeping user and root files intact..."
if ! sudo timeshift --create --comments "initial user state"; then
  error "Failed to create snapshot 'initial user state'. Aborting."
  exit 1
fi

# List snapshots
info "Listing current snapshots..."
if ! sudo timeshift --list; then
  error "Failed to list snapshots."
  exit 1
fi

info "Process completed successfully."
info "Proceso completado con éxito."

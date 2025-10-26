# Timeshift Auto Backup Script

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://raw.githubusercontent.com/AndyDevla/ipfs-auto-installer/main/ipfs-auto-installer.sh)

This script automates the installation, configuration, and initial snapshot creation process using Timeshift on Debian 13 in a Terminal. 

It checks if Timeshift is installed, updates and installs it if necessary, creates a backup of the configuration file, temporarily modifies the exclusion settings to create a snapshot of the entire system, then restores the original configuration to create a second snapshot keeping user files and the root folder intact.

Finally, it lists all existing snapshots. The script includes error handling and informative messages for easier monitoring.

## Features

- Creates both minimal and full system snapshots for flexible backups.
- Includes error handling and clear status messages for reliable execution.
- All snapshots created after the script execution will not be of the entire system.
- If you need to create another snapshot of the entire system, just run the script again.

## Running the script
Either copy/paste the commands below into your terminal, or download the repository to execute the script manually. Then sit back and relax while the script does the rest of the work for you.

### Online:
Open a terminal to execute a bash script directly from GitHub.
```sh
bash <(wget -qO- https://raw.githubusercontent.com/AndyDevla/timeshift-auto-backup/refs/heads/main/timeshift_auto_backup.sh)
```
#### or 
```sh
bash <(curl -sSL https://raw.githubusercontent.com/AndyDevla/timeshift-auto-backup/refs/heads/main/timeshift_auto_backup.sh)
```
### Offline:
Clone this repository to your local machine. Make the script executable with `chmod +x script.sh` and run it.
```sh
git https://github.com/AndyDevla/timeshift-auto-backup.git
cd timeshift_auto_backup
sudo bash timeshift_auto_backup.sh
```

## Timeshift Commands:
After running the script, you can use the following commands to view, create, restore, and delete snapshots:
```
sudo timeshift --create --comments "your comment"
sudo timeshift --list
sudo timeshift --restore 
sudo timeshift --delete
sudo timeshift --delete-all
```

## License

GNU General Public License v3.0

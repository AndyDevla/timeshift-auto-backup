# timeshift-auto-backup
## Automates Timeshift installation and creates two snapshots: one with all files excluded and another with the original settings. Includes error checks and status messages.

This script automates the installation, configuration, and snapshot creation process using Timeshift on Linux. 
It checks if Timeshift is installed, updates and installs it if necessary, creates a backup of the configuration file, 
temporarily modifies the exclusion settings to create an empty snapshot, then restores the original configuration 
to create a second snapshot with the full system state. Finally, it lists all existing snapshots. 
The script includes error handling and informative messages for easier monitoring.

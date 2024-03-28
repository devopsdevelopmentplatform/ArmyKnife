#!/bin/bash

# Exit script on any error
set -e

# Essential groups
essential_groups=("root" "sudo" "adm" "wheel" "staff" "users")

# Non-essential groups
non_essential_groups=("games" "news" "nogroup" "dip" "lpadmin" "mail" "src" "backup" "operator" "users" "guest" "nobody")

# Non-essential users typically not needed for a server environment
non_essential_users=("games" "news" "lp" "uucp" "nobody" "gnats")

# Function to check and create essential user groups
check_and_create_essential_groups() {
    echo "Checking and creating essential groups..."
    for group in "${essential_groups[@]}"; do
        if ! getent group "$group" >/dev/null; then
            echo "[INFO] Essential group $group is missing. Creating..."
            sudo groupadd "$group"
        fi
    done
    echo "[SUCCESS] All essential user groups are configured."
}

# Function to remove non-essential groups
remove_non_essential_groups() {
    echo "Removing non-essential groups..."
    for group in "${non_essential_groups[@]}"; do
        if getent group "$group" >/dev/null; then
            echo "[INFO] Removing non-essential group: $group"
            sudo groupdel "$group"
        fi
    done
    echo "[SUCCESS] Non-essential groups are removed."
}

# Function to disable non-essential users
disable_non_essential_users() {
    echo "Disabling non-essential users..."
    for user in "${non_essential_users[@]}"; do
        if getent passwd "$user" >/dev/null; then
            # Disable the user by setting an invalid shell
            echo "[INFO] Disabling login for user: $user"
            sudo usermod -s /usr/sbin/nologin "$user"
        fi
    done
    echo "[SUCCESS] Non-essential users are disabled."
}

# Main execution
echo "Starting security checks..."
check_and_create_essential_groups
remove_non_essential_groups
disable_non_essential_users
echo "Security checks completed."


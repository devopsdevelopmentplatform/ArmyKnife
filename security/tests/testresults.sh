#!/bin/bash

# Test if shell access for users is limited successfully
test_prevent_root_shell() {
    make prevent-root-shell
    
    # Check if shell access for root is limited (customize as per your script)
    if ! grep -q "root: /sbin/nologin" /etc/passwd; then
        echo "[SUCCESS] Shell access for root is limited."
    else
        echo "[FAILURE] Shell access for root is not limited."
    fi
}

test_disable_sudo_timeout() {
    make disable-sudo-timeout

    # Check if sudo reauthentication is enforced (customize as per your script)
    if sudo grep -q "Defaults timestamp_timeout=0" /etc/sudoers; then
        echo "[SUCCESS] Sudo reauthentication is enforced."
    else
        echo "[FAILURE] Sudo reauthentication is not enforced."
    fi
}

# Test if essential user groups are configured successfully
test_essential_groups() {
    make essential-groups

    # Check if essential user groups are configured (customize as per your script)
    if grep -q "essential_group" /etc/group; then
        echo "[SUCCESS] Essential user groups are configured."
    else
        echo "[FAILURE] Essential user groups are not configured."
    fi
}

# Test if non-essential service accounts are disabled successfully
test_disable_accounts() {
    make disable-accounts
    
    # Check if non-essential service accounts are disabled (customize as per your script)
    if ! grep -q "non_essential_account" /etc/passwd; then
        echo "[SUCCESS] Non-essential service accounts are disabled."
    else
        echo "[FAILURE] Non-essential service accounts are still enabled."
    fi
}
# Test if system updates are automated successfully
test_unattended_upgrades() {
    make unattended-upgrades
    
    # Check if unattended-upgrades is enabled
    if sudo dpkg-reconfigure -plow unattended-upgrades | grep -q "Automatic";
    then
        echo "[SUCCESS] System updates are automated."
    else
        echo "[FAILURE] System updates are not automated."
    fi
}

# Test if the root account is locked successfully
test_lockroot() {
    make lockroot

    if sudo passwd -S root | grep -q "Password locked"; then
        echo "[SUCCESS] Root account is locked."
    else
        echo "[FAILURE] Root account is not locked."
    fi
}

# Run the unit test for lockroot
test_lockroot
# Run the unit test for unattended-upgrades
test_unattended_upgrades
# Run the unit test for disable-accounts
test_disable_accounts
# Run the unit test for essential-groups
test_essential_groups
# Run the unit test for disable-sudo-timeout
test_disable_sudo_timeout
# Run the unit test for prevent-root-shell
test_prevent_root_shell


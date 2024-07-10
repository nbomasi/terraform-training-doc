#!/bin/bash

# Function to disable root login and enforce key-based authentication in the SSH configuration file
configure_ssh_security() {
  # Check if the system is Debian-based or Red Hat-based
  if [ -f /etc/debian_version ]; then
    echo "Detected Debian-based system."
  elif [ -f /etc/redhat-release ]; then
    echo "Detected Red Hat-based system."
  else
    echo "Unsupported Linux distribution."
    return 1
  fi
  echo "#########################################################"
  echo ""
  SSH_CONFIG_FILE="/etc/ssh/sshd_config"

  # Backup the original SSH configuration file
  cp "$SSH_CONFIG_FILE" "${SSH_CONFIG_FILE}.backup"

  echo "Original file backed up to ${SSH_CONFIG_FILE}.backup "

  echo "#########################################################"
  echo ""

  # Disable root login
  if ! grep -q "^PermitRootLogin" "$SSH_CONFIG_FILE"; then
    echo "PermitRootLogin no" >> "$SSH_CONFIG_FILE"
    echo "Root login disabled successfully."
  else
    sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONFIG_FILE"
    
    echo "Root login disabled successfully."
  fi
  echo "#########################################################"
  echo ""
  # Enable public key authentication
  if ! grep -q "^PubkeyAuthentication" "$SSH_CONFIG_FILE"; then
    echo "PubkeyAuthentication yes" >> "$SSH_CONFIG_FILE"
    echo "Public key authentication enabled successfully."
  else
    sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSH_CONFIG_FILE"
    echo "Public key authentication enabled successfully."
  fi
  
  echo "#########################################################"
  echo ""
  
  # Disable password authentication
  if ! grep -q "^PasswordAuthentication" "$SSH_CONFIG_FILE"; then
    echo "PasswordAuthentication no" >> "$SSH_CONFIG_FILE"
    echo "Password authentication disabled successfully."
  else
    sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$SSH_CONFIG_FILE"
    echo "Password authentication disabled successfully."
  fi
  echo "#########################################################"
  echo ""
  # Restart the SSH service to apply changes
  systemctl restart sshd

  systemctl status sshd

  # Check if the SSH service restarted successfully
  if [ $? -ne 0 ]; then
    echo "Failed to restart SSH service. Please check the SSH configuration."
    return 1
  fi
  
  echo "#########################################################"
  echo ""
  echo "Root login has been disabled and key-based authentication has been enforced in SSH configuration."
  return 0
}
# Call the function to configure SSH security
configure_ssh_security

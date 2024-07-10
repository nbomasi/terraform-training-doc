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

  # Enforce key-based authentication
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

  # Determine SSH service name
  if systemctl list-units --type=service | grep -q sshd.service; then
    SSH_SERVICE="sshd.service"
  elif systemctl list-units --type=service | grep -q ssh.service; then
    SSH_SERVICE="ssh.service"
  else
    echo "Failed to detect SSH service. Please check the SSH configuration."
    return 1
  fi

  # Restart SSH service
  if systemctl restart "$SSH_SERVICE"; then
    echo "##################################################"
    echo "# $SSH_SERVICE restarted successfully."
    echo "##################################################"
  else
    echo "##################################################"
    echo "# Failed to restart $SSH_SERVICE. Please check the SSH configuration."
    echo "##################################################"
    return 1
  fi

  echo "#########################################################"
  echo ""
  echo "Root login has been disabled and key-based authentication has been enforced in SSH configuration."
  return 0
}

# Function to configure the firewall
configure_firewall() {
  if [ -f /etc/debian_version ]; then
    # Debian-based systems
    if ! command -v ufw > /dev/null; then
      echo "##################################################"
      echo "# ufw not detected. Installing ufw..."
      echo "##################################################"
      sudo apt-get update -y
      sudo apt-get install -y ufw
      echo "##################################################"
      echo "# ufw installation completed."
    else
      echo "##################################################"
      echo "# ufw is already installed."
      echo "##################################################"
    fi
    echo "##################################################"
    echo "# Configuring firewall using ufw..."
    echo "##################################################"
    # Enable ufw
    ufw --force enable

    # Allow necessary services
    ufw allow ssh
    ufw allow http
    ufw allow https

    # Deny all other incoming connections by default
    ufw default deny incoming

    # Allow all outgoing connections by default
    ufw default allow outgoing

    # Reload ufw to apply changes
    ufw reload

    # Check ufw status
    ufw status verbose

  elif [ -f /etc/redhat-release ]; then
    # RedHat-based systems
    if ! command -v firewalld > /dev/null; then
      echo "##################################################"
      echo "# firewalld not detected. Installing firewalld..."
      echo "##################################################"
      sudo yum install -y firewalld
      echo "##################################################"
      echo "# firewalld installation completed."
    else
      echo "##################################################"
      echo "# firewalld is already installed."
      echo "##################################################"
    fi
    echo "##################################################"
    echo "# Configuring firewall using firewalld..."
    echo "##################################################"
    # Start and enable firewalld
    systemctl start firewalld
    systemctl enable firewalld

    # Allow necessary services
    firewall-cmd --permanent --add-service=ssh
    firewall-cmd --permanent --add-service=http
    firewall-cmd --permanent --add-service=https

    # Reload firewalld to apply changes
    firewall-cmd --reload

    # Check firewalld status
    firewall-cmd --list-all

  else
    echo "##################################################"
    echo "# Unsupported Linux distribution."
    echo "##################################################"
    return 1
  fi

  echo "##################################################"
  echo "# Firewall has been configured."
  echo "##################################################"
  return 0
}

# Call the SSH security configuration function
configure_ssh_security

# Capture the exit code of the function
exit_code=$?

# Save the exit code to /opt/script-error
echo $exit_code > /opt/script-error

# If the SSH security configuration was successful, configure the firewall
if [ $exit_code -eq 0 ]; then
  configure_firewall
  exit_code=$?
fi

# Optionally, exit with the captured exit code
exit $exit_code
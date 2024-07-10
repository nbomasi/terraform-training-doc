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
  
  SSH_CONFIG_FILE="/etc/ssh/sshd_config"

  # Backup the original SSH configuration file
  cp "$SSH_CONFIG_FILE" "${SSH_CONFIG_FILE}.bak"

  # Disable root login by modifying the PermitRootLogin directive
  sed -i 's/^PermitRootLogin\s\+.*/PermitRootLogin no/' "$SSH_CONFIG_FILE"

  echo ""

  # If the PermitRootLogin directive is not present, add it to the file
  if ! grep -q "^PermitRootLogin" "$SSH_CONFIG_FILE"; then
    echo "PermitRootLogin no" >> "$SSH_CONFIG_FILE"
  fi

  # if ! grep -q "^PermitRootLogin" "$SSH_CONFIG_FILE"; then
  #   echo "PermitRootLogin no" >> "$SSH_CONFIG_FILE"
      echo "Root login disabled successfully"
  # elif
  #   echo "PermitRootLogin is already set in $SSH_CONFIG_FILE"
  #   sed -i 's/^PermitRootLogin\s\+.*/PermitRootLogin no/' "$SSH_CONFIG_FILE"
      echo "Root login disabled successfully"
    # else
    # echo "PermitRootLogin is already set in $SSH_CONFIG_FILE"

  # fi
  #
  # Enable public key authentication
  # if ! grep -q "^PubkeyAuthentication" "$SSH_CONFIG_FILE"; then
  #  echo "PubkeyAuthentication yes" >> "$SSH_CONFIG_FILE"
  #  echo "public key authentication successful"
  # elif
  #   echo "PubkeyAuthentication available in $SSH_CONFIG_FILE"
  #   sed -i 's/^#PubkeyAuthentication\s\+.*/PubkeyAuthentication yes/' "$SSH_CONFIG_FILE"
  #  echo "public key authentication successful"
    # else
    # echo "PubkeyAuthentication is already set in $SSH_CONFIG_FILE"
  # fi

    # if ! grep -q "^PasswordAuthentication" "$SSH_CONFIG_FILE"; then
    # echo "PasswordAuthentication no" >> "$SSH_CONFIG_FILE"
  #  echo "Password authetication disabled successfully"
  # elif
  #   echo "PasswordAuthentication available in $SSH_CONFIG_FILE"
  #   sed -i 's/^PasswordAuthentication\s\+.*/PasswordAuthentication no/' "$SSH_CONFIG_FILE"
  #  echo "Password authentication disabled successfully"
    #  else
    #   echo "PasswordAuthentication is already set in $SSH_CONFIG_FILE"
  # fi


  # Enforce key-based authentication
  # Enable PubkeyAuthentication
  sed -i 's/^#PubkeyAuthentication\s\+.*/PubkeyAuthentication yes/' "$SSH_CONFIG_FILE"
  if ! grep -q "^PubkeyAuthentication" "$SSH_CONFIG_FILE"; then
    echo "PubkeyAuthentication yes" >> "$SSH_CONFIG_FILE"
  fi

  # Disable password authentication
  sed -i 's/^PasswordAuthentication\s\+.*/PasswordAuthentication no/' "$SSH_CONFIG_FILE"
  if ! grep -q "^PasswordAuthentication" "$SSH_CONFIG_FILE"; then
    echo "PasswordAuthentication no" >> "$SSH_CONFIG_FILE"
  fi

  # Restart the SSH service to apply changes
  systemctl restart sshd

  # Check if the SSH service restarted successfully
  if [ $? -ne 0 ]; then
    echo "Failed to restart SSH service. Please check the SSH configuration."
    return 1
  fi

  echo "Root login has been disabled and key-based authentication has been enforced in SSH configuration."
  return 0
}

# Function to configure the firewall
configure_firewall() {
  if [ -f /etc/debian_version ]; then
    # Debian-based systems
    if command -v ufw > /dev/null; then
      echo "Configuring firewall using ufw..."
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
    if command -v firewalld > /dev/null; then
      echo "Configuring firewall using firewalld..."
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
    echo "Unsupported Linux distribution."
    return 1
  fi

  echo "Firewall has been configured."
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


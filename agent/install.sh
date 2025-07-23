#!/bin/bash
set -e

# Check if the script is being run as root
if [ "$(id -u)" -eq 0 ]; then
    echo "⚠️ Warning: You are running this script as root!"
    echo "It's recommended to run this script as a non-root user to avoid potential security issues."
    read -p "Do you want to continue? [Y/n]: " choice
    case "$choice" in
        [Yy]* ) echo "Continuing...";;
        [Nn]* ) echo "Exiting script."; exit 1;;
        * ) echo "Invalid input, exiting script."; exit 1;;
    esac
fi


## PREPARING
echo "📲 Downloading agent content"
REPO_URL="https://github.com/PPGCC-GRIN-PUCRS/EdgePlatform.git"
if [ -d "/tmp/agent" ] || [ -d "$HOME/agent" ]; then
  echo "Agent on disk, using local content"
else
  echo "Agent not found locally. Downloading agent content..."
  git clone "$REPO_URL" "/tmp/grin"
  if [ $? -eq 0 ]; then
    GIT_CLONED=true
    echo "Repository downloaded successfully."
  else
    echo "Error during content download."
    exit 1
  fi
  cp -r /tmp/grin/agent /tmp/agent
  sudo rm -rf /tmp/grin
  cd /tmp/agent
fi

# Check for --debug flag
DEBUG=false
CLEAN=false
CLEAN_LOGS=false
CLEAN_CACHE=false
for arg in "$@"; do
  if [ "$arg" == "--debug" ]; then
    DEBUG=true
    echo "🐞 Debug mode enabled: Spinner disabled, logs will be shown"
  elif [ "$arg" == "--clean" ]; then
    CLEAN=true
    echo "🧹 Clean mode enabled: Old logs will be removed and cache ignored"
  elif [ "$arg" == "--clean-cache" ]; then
    CLEAN_CACHE=true
    echo "🧹 Clean cache mode enabled: Cache will be ignored"
  elif [ "$arg" == "--clean-logs" ]; then
    CLEAN_LOGS=true
    echo "🧹 Clean logs mode enabled: Old logs will be removed"
  fi
done

spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    local i=0

    while ps -p $pid > /dev/null 2>&1; do
        printf "\r📦 Installing Python package [%c]" "${spinstr:i++%${#spinstr}:1}"
        sleep $delay
    done

    printf "\r📦 Installing Python package [✅] Installed\n"
}



## BEGIN
echo "🚀 Starting agent installation"

# Define paths
SYSTEMD_SERVICE="/etc/systemd/system/agent.service"
ERR_FILE="/var/log/agent.error.log"
LOG_FILE="/var/log/agent.log"
DATA_DIR="/var/lib/agent"
CONFIG_DIR="/etc/agent"
CURRENT_USER=$(whoami)
AGENT_USER="agent"

CURRENT_USER_DIR=$(eval echo ~$CURRENT_USER)


# Create agent user with same groups as current user
if id "agent" &>/dev/null; then
    echo "👤 User 'agent' already exists - skipped"
else
    echo "👤 Creating user 'agent'"
    sudo useradd -m -s /bin/bash agent
    # Add agent user to same groups as the current user
    CURRENT_GROUPS=$(id -nG "$CURRENT_USER")
    for group in $CURRENT_GROUPS; do
        sudo usermod -aG "$group" agent
    done
    echo "✅ User 'agent' created and added to groups: [$CURRENT_GROUPS]"
fi
# Create the group "agent" if it does not exist
if ! getent group agent > /dev/null 2>&1; then
  echo "🧑‍🤝‍🧑 Creating group 'agent'"
  sudo groupadd agent
else
  echo "🧑‍🤝‍🧑 Group 'agent' already exists - skipped"
fi
# Add the "agent" user to the "agent" group
echo "👥 Adding 'agent' user to the 'agent' group"
sudo usermod -aG agent agent
# Add the current user to the "agent" group
echo "👥 Adding current user ('$CURRENT_USER') to the 'agent' group"
sudo usermod -aG agent "$CURRENT_USER"
echo "👥 Adding users ['agent', '$CURRENT_USER'] to the 'adm' group"
sudo usermod -aG adm "$CURRENT_USER"
sudo usermod -aG adm "agent"

# Remove existing config directory (optional, if you want fresh install)
if [ -d "$CONFIG_DIR" ]; then
  echo "🧹 Removing existing config directory: $CONFIG_DIR"
  sudo rm -rf "$CONFIG_DIR"
fi

# Recreate config directory
echo "📁 Creating config directory: $CONFIG_DIR"
sudo mkdir -p "$CONFIG_DIR"
sudo cp agent/config.yaml "$CONFIG_DIR/config.yaml"

# Ensure data directory exists
echo "📁 Creating data directory: $DATA_DIR"
sudo mkdir -p "$DATA_DIR"
sudo chown "$AGENT_USER" "$DATA_DIR"

# Ensure log file exists, and remove any old logs
if [ "$CLEAN" = true ] || [ "$CLEAN_LOGS" = true ]; then
    echo "🧹 Cleaning log files: [$LOG_FILE, $ERR_FILE]"
    sudo rm -f "$LOG_FILE"
    sudo rm -f "$ERR_FILE"
fi

# Change ownership if necessary
sudo chown $CURRENT_USER:agent $CURRENT_USER_DIR
sudo chmod 755 "$CURRENT_USER_DIR"

# Ensure log file exists
sudo chmod 775 /var/log
sudo chown root:agent /var/log

echo "📝 Creating log file: $LOG_FILE"
sudo touch "$LOG_FILE"
sudo chmod 664 "$LOG_FILE"
# sudo chown :agent "$LOG_FILE"
sudo chown :agent "$LOG_FILE"

echo "📝 Creating error log file: $ERR_FILE"
sudo touch "$ERR_FILE"
sudo chmod 664 "$ERR_FILE"
# sudo chown :agent "$ERR_FILE"
sudo chown :agent "$ERR_FILE"


# Remove old systemd files if needed
if [ -f "$SYSTEMD_SERVICE" ]; then
  echo "🧹 Removing old systemd service"
  sudo systemctl stop agent.service || true
  sudo systemctl disable agent.service || true
  sudo rm -f "$SYSTEMD_SERVICE"
fi


# Copy fresh systemd service file
echo "📦 Installing systemd service"
sed -e "s|__USER__|$AGENT_USER|g" \
    -e "s|__LOG-FILE__|$LOG_FILE|g" \
    -e "s|__ERROR-FILE__|$ERR_FILE|g" \
    -e "s|__WORKING-DIR__|$CURRENT_USER_DIR|g" \
    systemd/agent.service > /tmp/agent.service
sudo mv /tmp/agent.service "$SYSTEMD_SERVICE"
sudo chmod 644 "$SYSTEMD_SERVICE"


echo "🛠  Setting owner in config.yaml to $AGENT_USER"
sudo sed -i "s/^  owner: .*/  owner: \"$AGENT_USER\"/" "$CONFIG_DIR/config.yaml"


# Determine the pip install flags
INSTALL_FLAGS="--break-system-packages --force-reinstall"
[ "$CLEAN" = true ] || [ "$CLEAN_CACHE" = true ] && INSTALL_FLAGS="$INSTALL_FLAGS --no-cache-dir"
[ "$DEBUG" = true ] || INSTALL_FLAGS="$INSTALL_FLAGS --quiet"
# Install the package with or without debug
if [ "$DEBUG" = true ]; then
  echo "📦 Installing Python package (with logs)"
  pip install . $INSTALL_FLAGS
else
  (pip install . $INSTALL_FLAGS) & spinner
fi

if [ -f "/usr/local/bin/agent" ]; then
  echo "🧹 Removing existing agent at /usr/local/bin/agent"
  sudo rm -f /usr/local/bin/agent
fi

# Move CLI tool to global bin path
AGENT_BIN="$(python3 -m site --user-base)/bin/agent"
if [ -f "$AGENT_BIN" ]; then
  echo "🔀 Moving agent CLI to /usr/local/bin"
  sudo cp "$AGENT_BIN" /usr/local/bin/agent
  sudo chmod +x /usr/local/bin/agent
else
    echo "❌ Could not find agent binary at $AGENT_BIN"
    exit 1
fi


# Reload systemd and enable the service
echo "📦 Reloading Systemctl"
sudo systemctl daemon-reload
sudo systemctl enable agent.service
sudo systemctl restart agent.service


echo "✅ agent CLI is now available globally!"
echo "✅ Agent installed and running!"


if ! command -v k3s >/dev/null 2>&1; then
  echo ""
  echo "👉 Next steps: agent install to add missing packages"
fi

# If git cloned, remove temp files
if [ "$GIT_CLONED" = true ]; then
  echo "Removing cloned content at /tmp/agent"
  cd ..
  sudo rm -rf "/tmp/agent"
fi
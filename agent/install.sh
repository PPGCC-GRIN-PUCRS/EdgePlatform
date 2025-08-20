#!/bin/bash
# Exit the script immediately if any command returns a non-zero (error) exit code.
set -e


#
# VARIABLES SET
#

AGENT_INSTALL_SCRIPT="https://grin.logiclabsoftwares.com/api/agent/install.sh"
REPOSITORY_URL="https://github.com/PPGCC-GRIN-PUCRS/EdgePlatform.git"
SYSTEMD_SERVICE="/etc/systemd/system/agent.service"
ERR_FILE="/var/log/agent.error.log"
LOG_FILE="/var/log/agent.log"
DATA_DIR="/var/lib/agent"
CONFIG_DIR="/etc/agent"
AGENT_USER="agent"

INSTALL_PREFIX="/usr/local"

CURRENT_USER=$(whoami)
CURRENT_USER_DIR=$(eval echo ~$CURRENT_USER)

PYTHON_INSTALL_VERSION=3.11.7
MIN_PYTHON_VERSION=3.10

REBOOT_RECOMMENDED="N"

#
# FUNCTIONS
#

# Returns 0 if $1 >= $2, 1 else
# Uses sort -V to compare versions

version_ge() {
  printf '%s\n%s\n' "$2" "$1" | sort -C -V
}


install_package() {
    PACKAGE_NAME="$1"
    
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y "$PACKAGE_NAME"
        elif command -v dnf &> /dev/null; then
        sudo dnf install -y "$PACKAGE_NAME"
        elif command -v yum &> /dev/null; then
        sudo yum install -y "$PACKAGE_NAME"
        elif command -v pacman &> /dev/null; then
        sudo pacman -Sy --noconfirm "$PACKAGE_NAME"
        elif command -v apk &> /dev/null; then
        sudo apk add "$PACKAGE_NAME"
        elif command -v zypper &> /dev/null; then
        sudo zypper install -y "$PACKAGE_NAME"
    else
        echo "❌ Package manager not supported or not detected."
        exit 1
    fi
}


spinner() {
    MESSAGE="$1"
    DONE_MESSAGE="$2"
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    local i=0
    
    while ps -p $pid > /dev/null 2>&1; do
        printf "\r$MESSAGE [%c]" "${spinstr:i++%${#spinstr}:1}"
        sleep $delay
    done
    
    printf "\r$MESSAGE $DONE_MESSAGE\n"
}


# Find available python version
# Note that the python version should be greater or equal than $MIN_PYTHON_VERSION
find_python() {
  found_py=""
  found_py_version=""
  for ver in 3.10 3.11 3.12; do
    if command -v "python$ver" &> /dev/null; then
      v_full=$("python$ver" --version 2>&1 | awk '{print $2}')
      if version_ge "$v_full" "$MIN_PYTHON_VERSION"; then
        found_py="python$ver"
        found_py_version="$ver"
        break
      fi
    fi
  done
}



#
# REQUIREMENT SET
#

echo "🧹 Cleaning before start"
rm -rf ~/.local/lib/python3.7/site-packages/agent
rm -rf ~/.local/lib/python3/site-packages/agent
rm -rf ~/.local/lib/python/site-packages/agent
rm -f ~/.local/bin/agent


# Check if the script is being run as root
if [ "$(id -u)" -eq 0 ]; then
    echo "⚠️ Warning: You are running this script as root!"
    echo "It's recommended to run this script as a non-root user to avoid potential security issues."
    if [ -t 0 ]; then
      read -p "Do you want to continue? [Y/n]: " rootchoice
    else
      rootchoice="N"
    fi

    case "$rootchoice" in
        [Yy]* ) echo "Continuing...";;
        [Nn]* ) echo "Exiting script."; exit 1;;
        * ) echo "$rootchoice is a invalid input, exiting script."; exit 1;;
    esac
fi


find_python
# If a suitable python is NOT found
if [ -z "$found_py" ]; then
  echo "🪤 WARN: Python >= $MIN_PYTHON_VERSION is not installed."
  if [ -t 0 ]; then
    read -p "Do you want this script to auto-install Python $PYTHON_INSTALL_VERSION? [Y/n]: " installpython
  else
    installpython="Y"
  fi

  case "$installpython" in
    [Yy]* )
      echo "📦 Installing Python $PYTHON_INSTALL_VERSION..."
      cd /tmp || { echo "❌ Failed to enter /tmp"; exit 1; }
      wget -q https://www.python.org/ftp/python/$PYTHON_INSTALL_VERSION/Python-$PYTHON_INSTALL_VERSION.tgz
      tar -xf Python-$PYTHON_INSTALL_VERSION.tgz
      cd Python-$PYTHON_INSTALL_VERSION || { echo "❌ Failed to enter Python source dir"; exit 1; }
      ./configure --enable-optimizations --prefix="$INSTALL_PREFIX"
      make -j$(nproc)
      sudo make altinstall
      found_py="$INSTALL_PREFIX/bin/python3.11"
      REBOOT_RECOMMENDED="Y"
      ;;
    [Nn]* )
      echo "🚪 Exiting script."
      exit 1
      ;;
    * )
      echo "❌ Invalid input: $installpython"
      exit 1
      ;;
  esac

  # Detect if the updated pip is in ~/.local/bin and not in PATH
  if [[ ":$PATH:" != *":$INSTALL_PREFIX/bin:"* ]]; then
    echo "🔧 Adding $INSTALL_PREFIX/bin to PATH for this session."
    export PATH="$INSTALL_PREFIX/bin:$PATH"
  fi
  # Persist the change for future sessions
  if ! grep -q "$INSTALL_PREFIX/bin" ~/.bashrc; then
    echo "📌 Persisting PATH update to ~/.bashrc"
    echo "export PATH=\"$INSTALL_PREFIX/bin:\$PATH\"" >> ~/.bashrc
  fi

else
  echo "🐍 Found suitable Python version: $($found_py --version)"
fi

find_python
if [ -n "$found_py" ]; then
  current_py_path="$(readlink -f "$(command -v python)" || true)"
  found_py_path="$(readlink -f "$(command -v "$found_py")")"

  if [ "$current_py_path" != "$found_py_path" ]; then
    if [ -t 0 ]; then
      echo "⚠️  WARNING: The current default 'python' is NOT '$found_py'."
      echo "    It is recommended to change the default to avoid compatibility issues."
      read -p "Do you want to set '$found_py' as the default 'python'? [Y/n]: " change_default
    else
      change_default_python="Y"
    fi

    case "$change_default_python" in
      [Yy]* )
        echo "🔧 Setting $found_py as default python..."
        sudo ln -sf "$found_py_path" /usr/local/bin/python
        echo "✅ Now 'python' points to: $(python --version 2>&1)"
        REBOOT_RECOMMENDED="Y"
        ;;
      [Nn]* )
        echo "⚠️  Continuing without changing the default python. Errors may occur if 'python' points to an unsupported version."
        ;;
      * )
        echo "❌ Invalid input: $change_default_python"
        exit 1
        ;;
    esac
  else
    echo "ℹ️ 'python' already points to $found_py ($found_py_path)"
  fi
fi

reboot_time=5
case "$REBOOT_RECOMMENDED" in
    [Yy]* )
      echo "Since there was installations, it is recommemded a reboot before continue."
      echo "Your system will be rebooted in $reboot_time minutes."
      (crontab -l 2>/dev/null; echo "@reboot bash -c 'wget -O - $AGENT_INSTALL_SCRIPT | bash' # GRIN_AGENT_RUN_ONCE") | crontab -
      sudo /sbin/shutdown -r $reboot_time
      echo "If you want to cancel this action, execute the command \"sudo shutdown -c\""
      echo "But remember that if the system did not get rebooted before continue, errors may occur"
      exit 0
      ;;
    [Nn]* ) echo "ℹ️ No pre-installation was needed. Following with the agent install.";;
    * ) echo "$REBOOT_RECOMMENDED is a invalid input, exiting script."; exit 1;;
esac

crontab -l | grep -v 'GRIN_AGENT_RUN_ONCE' | crontab -

echo "✅ Removed @reboot crontab entry."

# Agora garanta usar essa versão
alias python3="$found_py"
alias pip3="${found_py/python/pip}"

# Guarantee that pre-requirements are available
if ! command -v "pip" &> /dev/null; then
  echo "🪤 WARN: the required command 'pip' is not installed."
  if [ -t 0 ]; then
    read -p "Do you want this script to auto-install it? [Y/n]: " installpip
  else
    installpip="Y"
  fi
  
  case "$installpip" in
    [Yy]* ) echo "📦 Installing pip...";;
    [Nn]* ) echo "🚪 Exiting script."; exit 1;;
    * ) echo "❌ Invalid input: $installpip"; exit 1;;
  esac
  
  install_package $found_py-pip
  
  echo "📦 Checking for pip update..."
  $found_py -m pip install --upgrade --user pip --no-warn-script-location
  $found_py -m ensurepip --upgrade
  $found_py -m pip install --upgrade pip
  
  # Detect if the updated pip is in ~/.local/bin and not in PATH
  LOCAL_BIN="$HOME/.local/bin"
  if [ ! "$(echo $PATH | grep "$LOCAL_BIN")" ]; then
    echo "🔧 Adding $LOCAL_BIN to PATH for this session."
    export PATH="$LOCAL_BIN:$PATH"
  fi

  # Persist the change for future sessions
  if ! grep -q "$LOCAL_BIN" ~/.bashrc; then
    echo "📌 Persisting PATH update to ~/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  fi

  if ! command -v pip &> /dev/null && command -v pip3 &> /dev/null; then
    sudo ln -s /usr/bin/pip3 /usr/bin/pip
  fi
fi

# Content gathering
echo "📲 Syncing agent content"
if [ -d "$HOME/agent" ]; then
  echo "👌 Agent on disk, using local content"
  cd "$HOME/agent"
else
  if [ -d "/tmp/agent" ]; then
    echo "✂️ Removing old cloned agent"
    sudo rm -rf /tmp/agent
  fi

  echo "🔻 Gethering agent content..."
  git clone "$REPOSITORY_URL" "/tmp/grin" #& spinner "🌏 Cloning global agent repository content" "[🧳] Clonned successfully"
  if [ $? -eq 0 ]; then
    GIT_CLONED=true
    echo "✅ Repository downloaded successfully."
  else
    echo "⚠️ Error during content download."
    exit 1
  fi
  sleep 5 #GARANTEE THAT
  cp -r /tmp/grin/agent /tmp/agent
  sudo rm -rf /tmp/grin
  cd /tmp/agent
fi



#
# AGENT INSTALL OPTIONS
#

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


#
# INSTALL SCRIPT
#

## BEGIN
echo "🚀 Starting agent installation"

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


######## QUARENTINE ################################################
###   This script part should be removed and the built agent should
### be acquired/downloaded from the artifact repository

# Determine the pip install flags
find_python
INSTALL_FLAGS="--break-system-packages --force-reinstall"
[ "$CLEAN" = true ] || [ "$CLEAN_CACHE" = true ] && INSTALL_FLAGS="$INSTALL_FLAGS --no-cache-dir"
[ "$DEBUG" = true ] || INSTALL_FLAGS="$INSTALL_FLAGS --quiet"
# Install the package with or without debug
if [ "$DEBUG" = true ]; then
  echo "📦 Installing Python package (with logs)"
  $found_py -m pip install . $INSTALL_FLAGS
else
  ($found_py -m pip install . $INSTALL_FLAGS) & spinner "📦 Installing Python package" "[✅] Installed"
fi

####################################################################


if [ -f "$INSTALL_PREFIX/bin/agent" ]; then
    echo "🧹 Removing existing agent at $INSTALL_PREFIX/bin/agent"
    sudo rm -f $INSTALL_PREFIX/bin/agent
fi

# Move CLI tool to global bin path
AGENT_BIN="$($found_py -m site --user-base)/bin/agent"
if [ -f "$AGENT_BIN" ]; then
    echo "🔀 Moving agent CLI to $INSTALL_PREFIX/bin"
    sudo cp "$AGENT_BIN" $INSTALL_PREFIX/bin/agent
    sudo chmod +x $INSTALL_PREFIX/bin/agent
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


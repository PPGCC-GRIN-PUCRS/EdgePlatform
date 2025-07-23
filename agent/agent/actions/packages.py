
from agent.actions.run_command import run_command
import shutil


def install_packages(k3s_version):
    install_k3s(k3s_version)
    install_tailscale()


def install_tailscale():
    # Check if Tailscale is already installed
    if shutil.which("tailscale"):
        print("✅ Tailscale is already installed. Skipping installation.")
        return run_command("tailscale version", True)
    
    # Update system and install curl
    run_command("sudo apt-get update", True)
    run_command("sudo apt-get install -y curl", True)

    # Install Tailscale using the official install script
    install_cmd = "curl -fsSL https://tailscale.com/install.sh | sh"
    run_command(install_cmd, True)

    # Enable and start the Tailscale service
    run_command("sudo systemctl enable --now tailscaled", True)

    # Verify installation
    return run_command("tailscale status", True)


def install_k3s(version: str = ''):
    # Check if K3s is already installed
    if shutil.which("k3s"):
        print("✅ K3s is already installed. Skipping installation.")
        run_command("k3s --version", True)
        return run_command("sudo k3s kubectl get node", True)
    
    # Update system packages (optional but recommended)
    run_command("sudo apt-get update", True)
    run_command("sudo apt-get install -y curl", True)

    # Build environment variables dynamically
    command_parts = []
    if version:
        command_parts.append(f'INSTALL_K3S_VERSION="{version}"')
    command_parts.append('INSTALL_K3S_EXEC="--write-kubeconfig-mode 644"')
    command = ' '.join(command_parts)
    # Final install command
    install_k3s = f'curl -sfL https://get.k3s.io | {command} sh -'

    # Install k3s using the official install script
    run_command(install_k3s, True)

    # Verify installation
    run_command("sudo k3s kubectl get node", True)
    
    return run_command("sudo kubectl version", True)



def uninstall_k3s():
    # Check if Tailscale is installed
    if not shutil.which("k3s"):
        print("ℹ️  Tailscale is not installed.")
        return
    # Uninstall k3s (works for single-node master setup)
    return run_command("sudo /usr/local/bin/k3s-uninstall.sh", True)


def uninstall_tailscale():
    # Check if Tailscale is installed
    if not shutil.which("tailscale"):
        print("ℹ️  Tailscale is not installed.")
        return

    print("🚧 Uninstalling Tailscale...")

    # Stop the Tailscale service
    run_command("sudo systemctl stop tailscaled", True)

    # Disable the service so it doesn't start on boot
    run_command("sudo systemctl disable tailscaled", True)

    # Remove the package
    run_command("sudo apt-get remove --purge -y tailscale", True)

    # Optionally, remove residual config files and dependencies
    run_command("sudo apt-get autoremove -y", True)
    run_command("sudo rm -rf /var/lib/tailscale /etc/default/tailscaled", True)

    print("✅ Tailscale uninstalled.")

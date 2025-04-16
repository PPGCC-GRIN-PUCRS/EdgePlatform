from agent.utils import load_config
import subprocess


def run_command(command, shell: bool = False):
    config = load_config()
    try:
        if (config['DEBUG']):
            print(f"Running: {command}")
        result = subprocess.run(
            command,
            shell=shell,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        if (config['DEBUG']):
            print(result.stdout)
        
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"❌ Command failed: {''.join(command)}")
        print(f"🔴 Return code: {e.returncode}")
        print(f"📥 STDERR:\n{e.stderr.strip()}")
        raise
    except Exception as e:
        print(f"\tUnexpected error while running: {' '.join(command)}\n\t{e}")
        print(f"\tCould also be lack of permissions.")
        print(f"🚨 Try --shell before the command instead.")
        raise



def install_k3s(version: str = ''):
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
    # Uninstall k3s (works for single-node master setup)
    return run_command("sudo /usr/local/bin/k3s-uninstall.sh", True)
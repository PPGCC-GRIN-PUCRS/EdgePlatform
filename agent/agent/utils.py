from pathlib import Path
import subprocess
import socket
import yaml


def load_config():
    default_path = Path(__file__).parent / "config.yaml"
    system_path = Path("/etc/agent/config.yaml")

    config_path = system_path if system_path.exists() else default_path

    with open(config_path, 'r') as f:
        return yaml.safe_load(f)


def get_hostname():
    return socket.gethostname()


def get_local_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
        return local_ip
    except Exception:
        return "127.0.0.1"


def get_vpn_ips():
    try:
        output = subprocess.check_output(["tailscale", "ip"], text=True).strip().splitlines()
        vpn_ipv6 = next((ip for ip in output if ":" in ip), "")
        vpn_ipv4 = next((ip for ip in output if "." in ip), "")
        return vpn_ipv4, vpn_ipv6
    except Exception as e:
        raise Exception(f"⚠️ Could not retrieve Tailscale IPs: {e}")


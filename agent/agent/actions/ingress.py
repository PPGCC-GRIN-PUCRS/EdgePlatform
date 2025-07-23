# ingress.py

from agent.utils import load_config, get_hostname, get_local_ip, get_vpn_ips
from datetime import datetime, timezone
import requests
import logging
import yaml
import os


def ingress(data: dict = None):
    config = load_config()

    timeout = int(config["platform"]["timeout"])
    host = config["platform"]["host"].rstrip("/")
    ingress_path = config["platform"]["endpoint"]["ingress"].lstrip("/")
    endpoint = f"{host}/{ingress_path}"

    # Fill full data if CLI passed partial overrides or no data at all
    if data is None:
        data = {}
    data = fill_missing_data(data)
    
    try:
        print(f"Ingress data:\n{data}")
        response = requests.post(endpoint, json=data, timeout=timeout)
        response.raise_for_status()
        print(f"✅ Ingress sent to {endpoint} (status {response.status_code})")
        save_response(response.json())
        return response.json()
    except requests.RequestException as e:
        print(f"❌ Failed to send ingress: {e}")
        return {"error": str(e)}
    



## HELPERS ## 

def save_response(data):
    config = load_config()
    path = config["ingress"].get("save_path", "/tmp/ingress_response.yml")

    # Ensure directory exists
    os.makedirs(os.path.dirname(path), exist_ok=True)

    with open(path, "w") as f:
        yaml.dump(data, f)
    print(f"📁 Saved ingress response to {path}")



def fill_missing_data(data):
    data.setdefault("connections", {})
    connections = data["connections"]
    connections.setdefault("hostname", get_hostname())
    connections.setdefault("local", get_local_ip())
    if not connections.get("vpnIpv4") or not connections.get("vpnIpv6"):
        try:
            vpn_ipv4, vpn_ipv6 = get_vpn_ips()
            connections.setdefault("vpnIpv4", vpn_ipv4)
            connections.setdefault("vpnIpv6", vpn_ipv6)
        except Exception as e:
            logging.error(e)
    return data
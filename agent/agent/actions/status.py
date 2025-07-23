from agent.utils import load_config, get_hostname, get_local_ip, get_vpn_ips

def status():
    config = load_config()
    vpn_ipv4, vpn_ipv6 = get_vpn_ips()
    print("🔍 Agent Status")
    print(f"  Hostname     : {get_hostname()}")
    print(f"  Local IP     : {get_local_ip()}")
    print(f"  VPN IPv4     : {vpn_ipv4}")
    print(f"  VPN IPv6     : {vpn_ipv6}")
    print(f"  Platform     : {config['platform']['host'].rstrip('/')}")
    print(f"  Log File     : {config['logging']['log_file']}")
    print(f"  Log Err File : {config['logging']['error_log_file']}")
    print(f"")
    print(f"Analytics:")
    print(f"Last status sent at ")
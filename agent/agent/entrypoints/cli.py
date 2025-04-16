# agent/entrypoints/cli.py

from agent.actions.run_command import install_k3s, run_command, uninstall_k3s
from agent.actions.ingress import ingress
from agent.actions.status import status
import argparse

def run_cli():
    parser = argparse.ArgumentParser(description="Agent CLI")
    subparsers = parser.add_subparsers(dest="command", help="Available commands")

    # Ingress command
    ingress_parser = subparsers.add_parser("ingress", help="Send ingress data")
    ingress_parser.add_argument("--hostname", help="Override hostname")
    ingress_parser.add_argument("--local", help="Override local IP")
    ingress_parser.add_argument("--vpnIpv4", help="Override VPN IPv4")
    ingress_parser.add_argument("--vpnIpv6", help="Override VPN IPv6")

    # Status command
    subparsers.add_parser("status", help="Show agent status and config info")

    # Status command
    subparsers.add_parser("reload", help="Update configuration files")

    # K3S command
    install_parser = subparsers.add_parser("install", help="Install system requirements (K3s; ...)")
    install_parser.add_argument("--k3s-version", help="Change K3S version")
    subparsers.add_parser("uninstall", help="Uninstall system requirements (K3s; ...)")

    # cluster_parser.add_argument("execute", help="Command to be executed", nargs=argparse.REMAINDER)
    # Cluster
    cluster_parser = subparsers.add_parser("cluster", help="Install system requirements (K3s; ...)")
    cluster_subparsers = cluster_parser.add_subparsers(dest="cluster_command", required=True)
    cluster_subparsers.add_parser("token", help="Print join token")
    
    cluster_connect_parser = cluster_subparsers.add_parser("join", help="Join existing cluster")
    cluster_connect_parser.add_argument("--token", required=True, help="Join token")
    cluster_connect_parser.add_argument("--server", required=True, help="K3s server address")


    # Run commands
    run_parser = subparsers.add_parser("run", help="Execute command on host as agent")
    run_parser.add_argument("execute", help="Command to be executed", nargs=argparse.REMAINDER)
    run_parser.add_argument("--shell", help="Execute directly at shell (Not secure!)", action="store_true")

    return handle_command(parser)




def handle_command(parser):
    args = parser.parse_args()
    match args.command:
        case "ingress":
            data = None
            # If any args provided, override
            if any([args.hostname, args.local, args.vpnIpv4, args.vpnIpv6]):
                data = {
                    "connections": {
                        "hostname": args.hostname or "",
                        "local": args.local or "",
                        "vpnIpv4": args.vpnIpv4 or "",
                        "vpnIpv6": args.vpnIpv6 or "",
                    }
                }
            return ingress(data)
        
        case "status": return status()
        case "run": return run_command(args.execute, args.shell)
        case "install": return install_k3s(args.k3s_version)
        case "uninstall": return uninstall_k3s()
        case "cluster":
            match args.cluster_command:
                case "token": return run_command('sudo cat /var/lib/rancher/k3s/server/node-token', True)

        case "reload":
            return run_command([
                ["mv", "/home/grin/agent/agent/config.yaml", "/home/grin/agent/agent/config.yaml"],
                ["cp", "/home/grin/agent/agent/config.yaml", "/etc/agent/config.yaml"]
            ], True)
        
        case _:
            parser.print_help()
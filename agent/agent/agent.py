from agent.entrypoints import cli, rest
import sys

def main():
    if len(sys.argv) > 1:
        cli.run_cli()
    else:
        rest.run_server()
    return
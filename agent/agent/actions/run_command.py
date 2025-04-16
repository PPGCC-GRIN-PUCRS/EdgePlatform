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
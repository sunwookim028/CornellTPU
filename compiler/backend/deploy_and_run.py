import subprocess
import getpass
import os

#configuration

BOARD_IP = "132.236.59.64"
USER = "xilinx"

LOCAL_FOLDER = r"deploy/CornellTPU"  
REMOTE_FOLDER = "~/CornellTPU"        # goes in xilinx home dir

# Host program & bitstream
HOST_CMD = "sudo python3 host.py tpu.bit instructions.txt"

#main script

def run():
    # Ask for password once
    password = getpass.getpass(f"Password for {USER}@{BOARD_IP}: ")

    # 1. SCP the folder to the board
    print("Copying folder to board with scp")
    scp_cmd = ["scp", "-r", LOCAL_FOLDER, f"{USER}@{BOARD_IP}:~"]
    subprocess.run(scp_cmd, check=True)

    # 2. SSH command: cd into the folder + run host
    remote_cmd = (
        f"cd {REMOTE_FOLDER} && "
        f"echo {password} | sudo -S {HOST_CMD}"
    )

    print("Running program on the board\n")

    ssh_cmd = ["ssh", f"{USER}@{BOARD_IP}", remote_cmd]
    subprocess.run(ssh_cmd, check=True)


if __name__ == "__main__":
    run()
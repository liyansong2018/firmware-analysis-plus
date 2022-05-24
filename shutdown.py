#!/usr/bin/env python3

import pexpect
import os.path
from configparser import ConfigParser
import re

config = ConfigParser()
config.read("fap.config")
firmadyne_path = config["DEFAULT"].get("firmadyne_path", "")
sudo_pass = config["DEFAULT"].get("sudo_password", "")

print ("[+] Shut down the virtual machine")
child = pexpect.spawn("/bin/sh" , ["-c", "sudo ps -ef | grep qemu-system-"], encoding="utf-8")
child.sendline(sudo_pass)
process = child.expect("qemu-system-")
process_info = child.before
process_id = re.findall(r'\d+', process_info)[0]
child.expect_exact(pexpect.EOF)

child = pexpect.spawn("/bin/sh" , ["-c", "sudo kill -9 " + process_id])
child.sendline(sudo_pass)
child.expect_exact(pexpect.EOF)

print ("[+] All done. Go ahead and run fap.py to continue firmware analysis")

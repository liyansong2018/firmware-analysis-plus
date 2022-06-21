#!/bin/sh
# python3

sudo apt update
sudo apt install -y python3-pip python3-pexpect unzip busybox-static fakeroot kpartx snmp uml-utilities util-linux vlan qemu-utils
sudo pip3 install python-magic -i https://pypi.mirrors.ustc.edu.cn/simple/

cd firmadyne

firmadyne_dir=$(realpath .)

# Set FIRMWARE_DIR in firmadyne.config
sed -i "/FIRMWARE_DIR=/c\FIRMWARE_DIR=$firmadyne_dir" firmadyne.config

# Comment out psql -d firmware ... in getArch.sh
sed -i 's/psql/#psql/' ./scripts/getArch.sh

# Change interpretor in extractor.py to python3
sed -i 's/env python/env python3/' ./sources/extractor/extractor.py
cd ..

#echo "Setting up firmware analysis plus"
#chmod +x fap.py
#chmod +x reset.py

# Set firmadyne_path in fap.config
sed -i "/firmadyne_path=/c\firmadyne_path=$firmadyne_dir" fap.config

echo "====================================================="
echo "Firmware Analysis Plus installed successfully!"
echo "Before running fap.py for the first time,"
echo "please edit fap.config and provide your sudo password"
echo "====================================================="

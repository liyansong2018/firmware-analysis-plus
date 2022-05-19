# Firmware Analysis Plus (Fap)

Fap is a greate simulator based on the [firmadyne](https://github.com/firmadyne/firmadyne)  that can run common router firmware from TP-Link, D-Link and other IoT manufacturer.

## Build

Installing Fap is easy. **We strongly recommend installing Fap on the latest version of Kali.**

```shell
git clone https://github.com/liyansong2018/firmware-analysis-plus.git
cd firmware-analysis-plus
./setup.sh
```

## Usage

Modify password in the `fap.config`

```Shell
[DEFAULT]
sudo_password=toor
firmadyne_path=/home/lys/Tools/firmware-analysis-plus/firmadyne
```

Monitor firmware

```Shell
./fap.py -q ./2.5.0/ ./testcases/iot.bin
```

Shut down the simulator

```
./shutdown.py
```

Reset the simulator

```shell
./reset.py
```

Help information

```shell
./fap.py --help                                          
usage: fap.py [-h] [-q qemu_path] [-b compiled_binwalk] [-t network_infer_time] firm_path

options:
  -h, --help            show this help message and exit
  -q qemu_path, --qemu qemu_path
                        The qemu version to use (must exist within qemu-builds directory). If not specified, the qemu
                        version installed system-wide will be used
  -b compiled_binwalk, --binwalk compiled_binwalk
                        Has binwalk been compiled? yes or no, 1 or 0
  -t network_infer_time, --time network_infer_time
                        Network infer time
```

## List of firmware supported

### Common

- [wnap320_V3.7.11.4_firmware.tar](https://github.com/liyansong2018/firmware-analysis-plus/tree/master/testcases)
- DIR-601_REVB_FIRMWARE_2.01.BIN
- DIR890A1_FW103b07.bin
- DIR-505L_FIRMWARE_1.01.ZIP
- DIR-615_REVE_FIRMWARE_5.11.ZIP
- DGL-5500_REVA_FIRMWARE_1.12B05.ZIP
- WRT54G3G_2.11.05_ETSI_code.bin
- NBG-416N_V1.00(USA.7)C0.zip
- TEW-638v2%201.1.5.zip
- Firmware_TEW-411BRPplus_2.07_EU.zip
- DGND3700 Firmware Version 1.0.0.17(NA).zip
- **DIR-300A1_FW105b09.bin**
- HG532eV100R001C01B020_upgrade_packet.bin
- DIR-860/865/880...
- ...

###  Custom

- [FAP-DIR2640.tar.bz2](https://github.com/liyansong2018/firmware-analysis-plus/releases)
- TL-WR802N(US)_V4_200
- Archer_C50v5_US_0.9.1_0.2
# firmware-analysis-plus

[![Python 3.7+](https://img.shields.io/badge/python-3.7+-3776AB?logo=Python&logoColor=FFFFFF&style=flat)](https://www.python.org/) [![issues](https://img.shields.io/github/issues/liyansong2018/firmware-analysis-plus)](https://github.com/liyansong2018/firmware-analysis-plus/issues) [![issues](https://img.shields.io/github/issues-closed/liyansong2018/firmware-analysis-plus)](https://github.com/liyansong2018/firmware-analysis-plus/issues?q=is%3Aissue+is%3Aclosed) [![license](https://img.shields.io/github/license/liyansong2018/firmware-analysis-plus)](https://github.com/liyansong2018/firmware-analysis-plus/blob/master/LICENSE) ![Visitor count](https://shields-io-visitor-counter.herokuapp.com/badge?page=liyansong2018.firmware-analysis-plus)

上游项目支持：[binwalk](https://github.com/ReFirmLabs/binwalk)、[firmadyne](https://github.com/firmadyne/firmadyne)、[firmware-analysis-toolkit](https://github.com/attify/firmware-analysis-toolkit)

**firmware-analysis-plus**（**fap**）主要用于常见**路由器固件的仿真**，可以进行固件的安全测试。感谢以下开源项目：`binwalk` 提供优秀的固件提取 API，`firmadyne` 提供优秀的固件仿真核心支持，`firmware-analysis-toolkit` 提供简化流程的思想。

**fap** 只是站在巨人的肩膀上，做出改进和定制，提供一个更加高效的仿真平台。包括精简不必要组件，优化仿真流程，优化网络环境大幅压缩安装时间，修复若干 `bug`，一键仿真固件。其原理主要包括两点

- `qemu` 提供多种架构指令的模拟，使用预先编译好的内核启动固件中的核心业务；
- 多数嵌入式设备含有一个 `nvram` 芯片，保存一些重要的配置信息，`firmadyne` 实现一个新的 `libnvram.so` 库文件，通过代码模拟固件启动时加载 `nvram` 配置信息的行为。


| FAP 版本                                                     | python 版本      | 支持系统                                        | 安装方法                                                     |
| ------------------------------------------------------------ | ---------------- | ----------------------------------------------- | ------------------------------------------------------------ |
| [v0.1](https://github.com/liyansong2018/firmware-analysis-plus/releases/tag/0.1) | python2、python3 | Ubuntu16.04 / Ubuntu 18.04 / Kali 2020.02         | [fap v0.1 版本手册](https://github.com/liyansong2018/firmware-analysis-plus/wiki/FAP-v0.1-%E7%89%88%E6%9C%AC%E6%89%8B%E5%86%8C) |
| [v1.0](https://github.com/liyansong2018/firmware-analysis-plus/releases/tag/1.0) | python2、python3 | Beta                                            | Beta                                                         |
| [v2.0](https://github.com/liyansong2018/firmware-analysis-plus/releases/tag/2.0) | python3          | Kali 2020.04 / Kali 2022.01 | 如下所示                                                     |

## 安装 binwalk

**Kali 2022 请忽略此步骤！最新版本 Kali 已经完美集成 binwalk 的 API**

以编译源码的方式安装`binwalk`，时至今日，`binwalk` 构建脚本中的诸多依赖已无法正常安装，于是自己 `fork` 了一份新的 `binwalk`，进行了修改。关于修改细节的描述，可参考：https://github.com/liyansong2018/binwalk

```
git clone https://github.com/liyansong2018/binwalk.git
cd binwalk
./deps.sh
sudo python3 setup.py install
```

## 安装 fap

```shell
git clone https://github.com/liyansong2018/firmware-analysis-plus.git
cd firmware-analysis-plus
./setup.sh
```

## 配置

修改 `fat.config` 文件中的密码，改为 `root` 系统用户的密码

## 运行

```
┌──(lys㉿kali)-[~/Documents/IoT/firmware-analysis-plus]
└─$ ./fat.py -q ./2.5.0/ ./testcases/wnap320_V3.7.11.4_firmware.tar                

             
                ______   _                ___                 
                |  ___| (_)              / _ \                
                | |_     _   _ __ ___   / /_\ \  _ __    ___  
                |  _|   | | | '_ ` _ \  |  _  | | '_ \  / __| ++
                | |     | | | | | | | | | | | | | | | | \__ \ 
                \_|     |_| |_| |_| |_| \_| |_/ |_| |_| |___/

                Welcome to the Firmware Analysis Plus - v2.1
 By lys - https://github.com/liyansong2018/firmware-analysis-plus | @liyansong
    
[+] Firmware: wnap320_V3.7.11.4_firmware.tar
[+] Extracting the firmware...
[+] Image ID: 3
[+] Identifying architecture...
[+] Architecture: mipseb
[+] Building QEMU disk image...
[+] Setting up the network connection, please standby...
[+] Network interfaces: [('brtrunk', '192.168.0.100')]
[+] Using qemu-system-mips from /home/lys/Documents/IoT/firmware-analysis-plus/qemu-builds/2.5.0
[+] All set! Press ENTER to run the firmware...
[+] When running, press Ctrl + A X to terminate qemu

```

此时回车，可以进入路由器的 shell，也可以打开 Web 端路由器管理页面。

## 关闭终端

```shell
./shutdown.py
```

## 重置和删除中间文件

```shell
./reset.py
```

## FAQ

### 编译 binwalk 失败怎么办？

如果已经编译好了 `binwalk`，可以使用如下命令进行固件仿真

```shell
./fat.py -q ./2.5.0/ ./testcases/wnap320_V3.7.11.4_firmware.tar 
```

如果编译 `binwalk` 失败，也没关系，`fap` 也支持不使用 `binwalk` 接口的模式，但是需要我们预先解压固件中的文件系统，并重新打包

```shell
tar -czvf test.tar.gz *		# 一定要在固件文件系统的根目录下重新打包
./fat.py -q ./2.5.0/ -b 0  ./testcases/test.tar.gz
```

### 支持的固件

fap 通用版（上游 firmadyne 项目提供）

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

fap 定制版（针对特定固件定制的版本）

- [FAP-DIR2640.tar.bz2](https://github.com/liyansong2018/firmware-analysis-plus/releases)
- TL-WR802N(US)_V4_200
- Archer_C50v5_US_0.9.1_0.2

## 相关研究

本工具的相关介绍以及一些安全研究员利用此工具发现或者复现的安全漏洞。

- [开源固件仿真平台fap对嵌入式固件的模拟与定制](https://www.freebuf.com/sectool/264053.html)
- [使用 firmware-analysis-plus 一键模拟固件](https://blog.csdn.net/song_lee/article/details/105518309)
- [固件远程登录及调试](https://github.com/liyansong2018/firmware-analysis-plus/wiki/%E5%9B%BA%E4%BB%B6%E8%BF%9C%E7%A8%8B%E7%99%BB%E9%99%86%E5%8F%8A%E4%BA%8C%E8%BF%9B%E5%88%B6%E8%B0%83%E8%AF%95)
- [手把手教你 | IoT设备漏洞复现到固件后门植入](https://zhuanlan.zhihu.com/p/353716569)
- [CVE-2019-17621 Dlink-859 RCE 复现](http://www.manongzj.com/blog/28-tkbcqqitdf.html)

## 已发现的安全漏洞

比较幸运的是，我们也是用该工具发现了一些路由器的安全漏洞，因此，使用 firmware-analysis-plus 不仅可以复现 IoT 固件安全漏洞，提供靶场和演练环境，也可以用于漏洞挖掘。2021 年通过 firmware-analysis-plus 发现的可以实现远程代码执行的漏洞如下

- [CVE-2021-29302](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-29302)
- [CVE-2021-34202](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-34202)
- [CVE-2021-34203](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-34203)

> 由于个人精力有限，加之上游项目 firmadyne 架构近几年没有进行调整，因此本项目近期不会更新，但是此工具仍然可用于 IoT 漏洞挖掘或者安全研究。

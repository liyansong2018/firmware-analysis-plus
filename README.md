# Firmware Analysis Plus (Fap) 

[![Python 3.7+](https://img.shields.io/badge/python-3.7+-3776AB?logo=Python&logoColor=FFFFFF&style=flat)](https://www.python.org/) [![issues](https://img.shields.io/github/issues/liyansong2018/firmware-analysis-plus)](https://github.com/liyansong2018/firmware-analysis-plus/issues) [![issues](https://img.shields.io/github/issues-closed/liyansong2018/firmware-analysis-plus)](https://github.com/liyansong2018/firmware-analysis-plus/issues?q=is%3Aissue+is%3Aclosed) [![license](https://img.shields.io/github/license/liyansong2018/firmware-analysis-plus)](https://github.com/liyansong2018/firmware-analysis-plus/blob/master/LICENSE) ![Visitor count](https://shields-io-visitor-counter.herokuapp.com/badge?page=liyansong2018.firmware-analysis-plus)

👉 [**English**](https://github.com/liyansong2018/firmware-analysis-plus/blob/master/README_EN.md)

上游项目支持：[binwalk](https://github.com/ReFirmLabs/binwalk)、[firmadyne](https://github.com/firmadyne/firmadyne)、[firmware-analysis-toolkit](https://github.com/attify/firmware-analysis-toolkit)


**firmware-analysis-plus**（**Fap**）主要用于常见**路由器固件的仿真**，可以进行固件的安全测试。感谢以下开源项目：`binwalk` 提供优秀的固件提取 API，`firmadyne` 提供优秀的固件仿真核心支持，`firmware-analysis-toolkit` 提供简化流程的思想。

**Fap** 只是站在巨人的肩膀上，做出改进和定制，提供一个更加高效的仿真平台。包括精简不必要组件，优化仿真流程，优化网络环境大幅压缩安装时间，修复若干 `bug`，一键仿真固件。其原理主要包括两点

- `qemu` 提供多种架构指令的模拟，使用预先编译好的内核启动固件中的核心业务；
- 多数嵌入式设备含有一个 `nvram` 芯片，保存一些重要的配置信息，`firmadyne` 实现一个新的 `libnvram.so` 库文件，通过代码模拟固件启动时加载 `nvram` 配置信息的行为。


| Fap 版本                                                     | 支持系统                                               | 备注                                                         |
| ------------------------------------------------------------ |  ------------------------------------------------------ | ------------------------------------------------------------ |
| [v0.1](https://github.com/liyansong2018/firmware-analysis-plus/releases/tag/v0.1) | Ubuntu16.04 / Ubuntu 18.04 / Kali 2020.02              | [Fap v0.1 版本手册](https://github.com/liyansong2018/firmware-analysis-plus/wiki/FAP-v0.1-%E7%89%88%E6%9C%AC%E6%89%8B%E5%86%8C) |
| [v1.0](https://github.com/liyansong2018/firmware-analysis-plus/releases/tag/v1.0) | Kali 2020.02                                           | 测试版本                                                     |
| [v2.0](https://github.com/liyansong2018/firmware-analysis-plus/releases/tag/v2.0) | Kali 2020.04 / Kali 2022.01                            | 备份fat                                                      |
| [v2.3](https://github.com/liyansong2018/firmware-analysis-plus/releases/tag/v2.3) | Ubuntu16.04 / Kali 2020.04                             | 修复多个bug                                                  |
| [v2.3.1](https://github.com/liyansong2018/firmware-analysis-plus/releases/tag/v2.3.1) | Ubuntu16.04 / Ubuntu18.04 / Ubuntu20.04 / Kali 2020.04 | 提高兼容性&添加Docker                                        |

🚩 **注意** 🚩

- 经过验证，Ubuntu2022 以及 Kali2022 最新版 binwalk 存在问题，许多固件无法提取根文件系统，固在此不推荐使用。
- Ubuntu 用户，可以按照如下方法使用；Kali 用户，可能需要源码编译 binwalk，否则只能使用无 binwalk 模式的 Fap（参见 FAQ）。

## Fap 常见用法

### 安装

```shell
git clone https://github.com/liyansong2018/firmware-analysis-plus.git
cd firmware-analysis-plus
./setup.sh
```

### 配置

修改 `fap.config` 文件中的密码，改为 `root` 系统用户的密码

### 运行

```
┌──(lys㉿kali)-[~/Documents/IoT/firmware-analysis-plus]
└─$ ./fap.py -q ./qemu-builds/2.5.0/ ./testcases/wnap320_V3.7.11.4_firmware.tar               

             
                ______   _                ___                 
                |  ___| (_)              / _ \                
                | |_     _   _ __ ___   / /_\ \  _ __    ___  
                |  _|   | | | '_ ` _ \  |  _  | | '_ \  / __| ++
                | |     | | | | | | | | | | | | | | | | \__ \ 
                \_|     |_| |_| |_| |_| \_| |_/ |_| |_| |___/

                Welcome to the Firmware Analysis Plus - v2.3.1
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

### 关闭终端

```shell
./shutdown.py
```

### 重置和删除中间文件

```shell
./reset.py
```

参数 `-t` 用于更改固件网络地址推断的默认时间；参数 `-q` 用于配置 binwalk。

## Docker

由于固件模拟在不同操作系统上会有不同的表现，经过众多安全研究者的强烈建议，Fap 2.3.1 已添加对 Docker 镜像的支持，如果你遇到了环境问题，可以直接使 fap-docker！

```shell
# 拉取镜像
sudo docker pull liyansong2022/fap-docker:2.3.1

# 创建容器
sudo docker run -it --privileged -p 8080:80 --name fap liyansong2022/fap-docker:2.3.1 /bin/bash

# 进入容器
sudo docker exec -t fap /bin/sh

# 使用Fap
root@a8e4d33280d9:/# cd root/firmware-analysis-plus/
root@a8e4d33280d9:~/firmware-analysis-plus# ./fap.py testcases/iot_dir880l_110b01.bin 

# 在docker容器内添加端口映射
root@a8e4d33280d9:/# vi /etc/rinetd.conf
0.0.0.0 80 192.168.0.1 80

root@a8e4d33280d9:/# pkill rinetd   		 # 关闭进程
root@a8e4d33280d9:/# rinetd -c /etc/rinetd.conf  # 启动转发
```

通过在宿主机上访问 http://127.0.0.1:8080 即可打开 docker 中的 qemu 模拟的固件。相比于直接使用 Fap，使用 docker 的缺陷是
- 如果要添加新的固件，需要手动修改 docker 容器的启动参数，共享文件；或者直接在容器中下载公网上的固件。
- 如果需要访问固件中的端口，也需要手动修改 docker 容器的启动参数，并在 docker 容器中自行添加端口映射。

## FAQ

### 编译 binwalk 失败或者解压镜像失败怎么办？

如果已经编译好了 `binwalk`，可以使用如下命令进行固件仿真

```shell
./fap.py -q /qemu-builds/2.5.0/ ./testcases/wnap320_V3.7.11.4_firmware.tar 
```

如果编译 `binwalk` 失败，也没关系，`fap` 也支持不使用 `binwalk` 接口的模式，但是需要我们预先解压固件中的文件系统，并重新打包

```shell
tar -czvf test.tar.gz *		# 一定要在固件文件系统的根目录下重新打包
./fap.py -q ./qemu-builds/2.5.0/ -b 0  ./testcases/test.tar.gz
```

常见问题请直接访问 [issue](https://github.com/liyansong2018/firmware-analysis-plus/issues)。

### 支持的固件

Fap 通用版（上游 firmadyne 项目提供）

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

Fap 定制版（针对特定固件定制的版本）

- [FAP-DIR2640.tar.bz2](https://github.com/liyansong2018/firmware-analysis-plus/releases)
- TL-WR802N(US)_V4_200
- Archer_C50v5_US_0.9.1_0.2

## 相关研究

本工具的相关介绍以及一些安全研究员利用此工具发现或者复现的安全漏洞。

- [cgibin中与upnp协议有关的一些漏洞分析与复现](https://bbs.pediy.com/thread-272634.htm)
- [手把手教你 | IoT设备漏洞复现到固件后门植入](https://zhuanlan.zhihu.com/p/353716569)
- [CVE-2019-17621 Dlink-859 RCE 复现](http://www.manongzj.com/blog/28-tkbcqqitdf.html)
- [开源固件仿真平台fap对嵌入式固件的模拟与定制](https://www.freebuf.com/sectool/264053.html)
- [使用 firmware-analysis-plus 一键模拟固件](https://blog.csdn.net/song_lee/article/details/105518309)
- [固件远程登录及调试](https://github.com/liyansong2018/firmware-analysis-plus/wiki/%E5%9B%BA%E4%BB%B6%E8%BF%9C%E7%A8%8B%E7%99%BB%E9%99%86%E5%8F%8A%E4%BA%8C%E8%BF%9B%E5%88%B6%E8%B0%83%E8%AF%95)

## 已发现的安全漏洞

比较幸运的是，我们也是用该工具发现了一些路由器的安全漏洞，因此，使用 Fap 不仅可以复现 IoT 固件安全漏洞，提供靶场和演练环境，也可以用于漏洞挖掘。2021 年通过Fap  发现的可以实现远程代码执行的漏洞如下

- [CVE-2021-29302](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-29302)
- [CVE-2021-34202](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-34202)
- [CVE-2021-34203](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-34203)

> 由于个人精力有限，加之上游项目 Firmadyne 架构近几年没有进行调整，因此本项目近期不会更新，但是此工具仍然可用于 IoT 漏洞挖掘或者安全研究。除基于 **Firmadyne** 的固件模拟项目之外，**EMUX(ARMX)** 也是仿真路由器固件不错的选择。

## 其他推荐

- [EMBA](https://github.com/e-m-b-a/emba) - The firmware security analyzer（固件分析工具，集成 firmadyne，但是环境复杂）
- [EMUX](https://github.com/therealsaumil/emux) - Firmware Emulation Framework (formerly ARMX)（路由器固件仿真）
- [FACT_core](https://github.com/fkie-cad/FACT_core) - Firmware Analysis and Comparison Tool


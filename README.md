# Firmware Analysis Plus (Fap) 

[![Python 3.7+](https://img.shields.io/badge/python-3.7+-3776AB?logo=Python&logoColor=FFFFFF&style=flat)](https://www.python.org/)
[![Ubuntu 20.04](https://img.shields.io/badge/Ubuntu-20.04-3776AB?logo=Ubuntu&logoColor=FFFFFF&style=flat)](https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/20.04/)
[![issues](https://img.shields.io/github/issues/liyansong2018/firmware-analysis-plus)](https://github.com/liyansong2018/firmware-analysis-plus/issues) 
[![issues](https://img.shields.io/github/issues-closed/liyansong2018/firmware-analysis-plus)](https://github.com/liyansong2018/firmware-analysis-plus/issues?q=is%3Aissue+is%3Aclosed) 
[![license](https://img.shields.io/github/license/liyansong2018/firmware-analysis-plus)](https://github.com/liyansong2018/firmware-analysis-plus/blob/master/LICENSE) 

👉 [**English**](https://github.com/liyansong2018/firmware-analysis-plus/blob/master/README_EN.md)

上游项目支持：[binwalk](https://github.com/ReFirmLabs/binwalk)、[firmadyne](https://github.com/firmadyne/firmadyne)、[firmware-analysis-toolkit](https://github.com/attify/firmware-analysis-toolkit)


**firmware-analysis-plus**（**Fap**）主要用于常见**路由器固件的仿真**，可以进行固件的安全测试。感谢以下开源项目：`binwalk` 提供优秀的固件提取 API，`firmadyne` 提供优秀的固件仿真核心支持，`firmware-analysis-toolkit` 提供简化流程的思想。

**Fap** 只是站在巨人的肩膀上，做出改进和定制，提供一个更加高效的仿真平台。包括精简不必要组件，优化仿真流程，优化网络环境大幅压缩安装时间，修复若干 `bug`，一键仿真固件。其原理主要包括两点

- `qemu` 提供多种架构指令的模拟，使用预先编译好的内核启动固件中的核心业务；
- 多数嵌入式设备含有一个 `nvram` 芯片，保存一些重要的配置信息，`firmadyne` 实现一个新的 `libnvram.so` 库文件，通过代码模拟固件启动时加载 `nvram` 配置信息的行为。

**推荐环境：Ubuntu 20.04 + [binwalk-f4a5759](https://github.com/liyansong2018/binwalk)**，如果配置环境出错，可以直接下载打包好的 [VMware 虚拟机镜像](https://pan.baidu.com/s/1eVNxoLKlqAQHcrSMfI7tQw?pwd=jpy4)；也可以使用 `docker-menu.sh` 脚本建立 Docker 容器，Docker 国内需要使用科学上网或配置源。

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


## FAQ

### 解压镜像失败怎么办？

**最近的 binwalk 似乎存在问题，无法解压很多镜像**（以前可以解压的镜像，例如 `DIR-300A1_FW105b09.bin`、`HG532eV100R001C01B020_upgrade_packet.bin`），因此推荐使用笔者打过 patch 的 [binwalk](https://github.com/liyansong2018/binwalk)，按照里面的说明直接编译即可。

如果已经编译好了 `binwalk`，可以使用如下命令进行固件仿真

```shell
./fap.py -q ./qemu-builds/2.5.0/ ./testcases/wnap320_V3.7.11.4_firmware.tar 
```


### 如何对固件进行重打包？

`fap` 也支持不使用 `binwalk` 接口的模式，但是需要我们预先解压固件中的文件系统，并重新打包

```shell
tar -czvf test.tar.gz *		# 一定要在固件文件系统的根目录下重新打包
./fap.py -q ./qemu-builds/2.5.0/ -b 0  ./testcases/test.tar.gz
```

如果你想修改固件的内容，可参考 Wiki: [固件远程登录及调试](https://github.com/liyansong2018/firmware-analysis-plus/wiki/%E5%9B%BA%E4%BB%B6%E8%BF%9C%E7%A8%8B%E7%99%BB%E9%99%86%E5%8F%8A%E4%BA%8C%E8%BF%9B%E5%88%B6%E8%B0%83%E8%AF%95)


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


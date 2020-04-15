# firmware-analysis-plus
本项目依赖于 [firmadyne](https://github.com/firmadyne/firmadyne) 以及 [firmware-analysis-toolkit](https://github.com/attify/firmware-analysis-toolkit)，修复了其中的大量bug，可直接运行固件。

### 准备
源码安装 binwalk，如果是 Kali 用户，自带了 binwalk，可忽略此步骤
```
# Python2.7
$ git clone https://github.com/ReFirmLabs/binwalk.git
$ cd binwalk
$ sudo python setup.py install
```

### 安装
运行 ./setup.sh 

### 运行

```
root@kali:~/Documents/firmware-analysis-plus# python3 fat.py 

             
		______   _                ___                 
		|  ___| (_)              / _ \                
		| |_     _   _ __ ___   / /_\ \  _ __    ___  
		|  _|   | | | '_ ` _ \  |  _  | | '_ \  / __| ++
		| |     | | | | | | | | | | | | | | | | \__ \ 
		\_|     |_| |_| |_| |_| \_| |_/ |_| |_| |___/

                Welcome to the Firmware Analysis Plus - v0.1
            By lys - hhttps://blog.csdn.net/song_lee | @liyansong
    
usage: fat.py [-h] [-q qemu_path] firm_path
fat.py: error: the following arguments are required: firm_path
```
例如
```
python3 fat.py -q /root/Documents/firmware-analysis-toolkit/qemu-builds/2.5.0/ /root/Documents/test/WNAP320_V3.7.11.4.zip
```

### 解答
如果遇到错误，请删除 `firmadyne` 目录下自动生成的镜像文件 `images` 以及文件系统 `scratch`，重新运行即可

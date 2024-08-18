#!/bin/bash
# 检测shell是否为bash
if [ -z "$BASH_VERSION" ]; then
    echo "请使用bash运行此脚本，不要使用sh"
    exit 1
fi

function menu {
    clear
    echo
    echo -e "\t\tDocker 启动菜单\n"
    echo -e "\t1. 启动容器"
    echo -e "\t2. 停止容器"
    echo -e "\t3. 删除容器"
    echo -e "\t4. 进入容器"
    echo 
    echo -e "\t<Any> 退出"
    echo -en "\t\t请输入选项:"
    read -n 1 option
}

function start {
    clear
    # 判断fap容器是否存在，存在则直接启动
    if [ $(sudo docker ps -a | grep fap | wc -l) -gt 0 ]; then
        echo -e "\n\n\t\t容器已存在，直接启动"
        echo "启动中..."
        sudo docker start fap
        return
    fi
    if [ -f run.sh ]; then
        echo -e "\n\n\t\t启动命令已存在，从run.sh文件启动；或是重新配置启动命令？"
        echo -en "\n\n\t\t是否从run.sh文件启动？(y/n):"
        echo -en "\n\n\t\trun.sh文件内容如下：\n\n"
        cat run.sh
        read -n 1 yn
        if [ "$yn" == "y" ]; then
            echo "启动中..."
            ./run.sh
            return
        fi
    fi
    echo -e "\n\n\t\t启动容器，容器名称默认为：fap"
    echo -e "\n\n\t\t请输入挂载路径，多条请使用半角分号分隔，例如：./:/root/mnt"
    read -e -p "请输入路径：" path
    echo -e "\n\n\t\t请输入端口映射，多条请使用半角分号分隔，例如：8080:80"
    read -e -p "请输入端口：" port
    allports=""
    allpath=""
    for i in $(echo $port | tr ";" "\n")
    do
        allports="-p $i $allports"
    done
    for i in $(echo $path | tr ";" "\n")
    do
        allpath="-v $i $allpath"
    done
    # 保存启动配置到配置文件
    echo "sudo docker run -it --privileged $allports $allpath --name fap liyansong2022/fap-docker:2.3.1 /bin/bash" > run.sh
    chmod +x run.sh
    echo "启动命令已保存到run.sh文件"
    cat run.sh
    echo "启动中..."
    ./run.sh
}

function stop {
    clear
    echo -e "\n\n\t\t停止容器"
    sudo docker stop fap
    echo -e "\n\n\t\t停止成功"
}

function delete {
    clear
    echo -e "\n\n\t\t删除容器"
    sudo docker rm -f fap
    echo -e "\n\n\t\t删除成功"
}

function enter {
    clear
    echo -e "\n\n\t\t进入容器"
    sudo docker exec -it fap /bin/bash
}

while [ 1 ]
do
    menu
    case $option in
    1) 
        start;;
    2)
        stop;;
    3)
        delete;;
    4)
        enter;;
    *)
        break;;
    esac
    echo -en "\n\n\t\t按任意键继续"
    read -n 1 line
done
clear

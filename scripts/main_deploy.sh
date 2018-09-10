#!/bin/bash

# 设置颜色变量
head_color='\033'
tail_color='\033[0m'
log_file="$(cd ../log;pwd)/action_all.log"

# 检查是否为root用户
check_user(){
    if [ $(id -u) -ne 0 ];then
        echo -e "$head_color[1;31m请使用root用户 $tail_color"
    fi
}

# 检查网络连通性
check_network(){
    ping -c 4 -i 0.1 www.baidu.com &>"$log_file"
    if [ "$?" -ne 0 ];then
        echo -e "$head_color[1;31m当前网络ping不通外网,请检查 $tail_color"
        read -p '如需查看详细提示请输入 y : ' n
        case $n in
            y|Y)
                echo -e "$head_color[1;35m检查如下:\n1.不允许连接外网\n2.禁用了icmp协议\n3.DNS配置有误\n请联系网管人员 $tail_color"
            ;;
            *)
                echo "再见！"
            ;;
        esac
        exit 1
    fi
}

# 判断输入的选项
check_action(){
    action=$(echo "$action"|tr [A-Z] [a-z])
    case "$action" in
        mysql)
            ./install_mysql.sh
        ;;
        nginx)
            ./install_nginx.sh
        ;;
        q|Q)
            exit 0
        ;;
        *)
            echo -e "$head_color[1;34m请输入正确的选项 $tail_color"
        ;;
    esac
}

menu(){
    check_user
    check_network
    while true
    do
        echo -e "$head_color[1;36m$(ls *|egrep -v 'main_deploy.sh'|awk -F'[_.]' '{print $2}')\n输入(q|Q)退出! $tail_color"
        read -p '您要安装什么? ' action
        check_action
    done
}
menu

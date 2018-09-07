#!/bin/bash

# 设置颜色变量
head_color='\033'
tail_color='\033[0m'
log_file='../log/nginx_all.log'

# 检查上一步操作是否成功
check_command(){
    if [ "$?" -ne 0 ];then
        echo -e "$head_color[1;31m安装出错了,拜拜 $tail_color"
    fi
}

# 根据系统安装依赖包
install_rely(){
    echo -e "$head_color[1;32m正在安装依赖包 $tail_color"
    if [ ! -z $(cat /etc/issue|egrep -oi 'S$') ];then
        yum -y install gcc pcre pcre-devel zlib zlib-devel openssl openssl-devel &>"$log_file"
    elif [ ! -z $(cat /etc/issue|egrep -oi 'ubuntu') ];then
        apt-get -y install gcc openssl openssl-devel libpcre3 libpcre3-dev zlib1g-dev make &>"$log_file"
    fi
}       

# 安装nginx
install_nginx(){    
    echo -e "$head_color[1;32m正在安装nginx $tail_color"
    wget -q http://nginx.org/en/download/nginx-1.12.2.tar.gz -P /root/ &>"$log_file"
    if [ -f '/root/nginx-1.12.2.tar.gz' ];then
        tar xf ~/nginx-1.12.2.tar.gz -C /usr/local/;cd /usr/local/nginx-1.12.2
        ./configure --prefix=/usr/local/nginx --sbin-path=/usr/bin/nginx &>$(cd -)/"$log_file";check_command && \
        make &>$(cd -)/"$log_file";check_command && make install &>$(cd -)/"$log_file";check_command && \
        echo -e "$head_color[1;32mnginx install success $tail_color"
    else
        echo -e "$head_color[1;31m源码包下载失败了哦 $tail_color"
        exit 1
    fi
}
install_rely
install_nginx

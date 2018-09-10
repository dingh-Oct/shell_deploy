#!/bin/bash
# mysql官网网址: https://dev.mysql.com
 
# 设置颜色变量
head_color='\033'
tail_color='\033[0m'
log_file="$(cd ../log;pwd)/mysql_all.log"

# 检查上一步操作是否成功
check_command(){
    if [ "$?" -ne 0 ];then
        echo -e "$head_color[1;31m安装出错了,拜拜 $tail_color"
        exit 1
    fi
}

# 根据系统安装依赖包
install_rely(){
    echo -e "$head_color[1;33m正在安装依赖包 $tail_color"
    if [ ! -z $(cat /etc/issue|egrep -oi 'S$') ];then
        yum -y install gcc gcc-c++ ncurses ncurses-devel cmake bison &>"$log_file"
    elif [ ! -z $(cat /etc/issue|egrep -oi 'ubuntu') ];then
        apt-get install -y make cmake gcc g++ perl bison libaio-dev libncurses5 libncurses5-dev libnuma-dev &>"$log_file"
    fi
}

install_mysql(){
    echo -e "$head_color[1;33m正在安装mysql $tail_color" 
    wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.23.tar.gz -P /root/ &>"$log_file"
    if [ -f '/root/mysql-5.7.23.tar.gz' ];then
        tar xf /root/mysql-5.7.23.tar.gz -C /root/;cd /root/mysql-5.7.23
        cmake \
        -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
        -DSYSCONFDIR=/etc \
        -DDEFAULT_CHARSET=utf8 \
        -DDEFAULT_COLLATION=utf8_general_ci \
        -DEXTRA_CHARSETS=all \
        -DDOWNLOAD_BOOST=1 &>"$log_file";check_command && make &>"$log_file";check_command && make install &>"$log_file";check_command
        cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
        chmod +x /etc/init.d/mysqld
        systemctl enable mysqld $>"$log_file"
        echo -e '\n\nexport PATH=/usr/local/mysql/bin:$PATH\n' >> /etc/profile && . /etc/profile
        mysqld --initialize-insecure --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/mysql_data &>"$log_file"
        systemctl start mysqld &>"$log_file" && echo -e "$head_color[1;32mmysql install success $tail_color"
    else
        echo -e "$head_color[1;31m源码包下载失败了哦 $tail_color"
        exit 1
    fi 
}
install_rely
install_mysql

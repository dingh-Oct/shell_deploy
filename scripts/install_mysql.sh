#!/bin/bash
# mysql官网网址: https://dev.mysql.com
 
# 设置颜色变量
head_color='\033'
tail_color='\033[0m'

echo -e "$head_color[1;32m正在安装mysql $tail_color" 
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.23.tar.gz

#!/usr/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#定义变量

##颜色    
##echo -e "${red}[填写文字]${plain}"
blue='\033[0;34m'
yellow='\033[0;33m'
green='\033[0;32m'
red='\033[0;31m'
plain='\033[0m'

##检查是否为Root
[ $(id -u) != "0" ] && { echo -e "${red}[错误]${plain} 你必须以 root 用户执行此安装程序"; exit 1; }





## ==卸载安骑士==

clean_up1() {
    echo "删除残留......."
}

clean_up() {

echo "# CentOS 安装依赖......."
yum -y install curl

echo "关闭firewalld防火墙......."
systemctl stop firewalld.service
systemctl disable firewalld.service

echo "[关闭]...云顿go语言......."
/usr/local/cloudmonitor/CmsGoAgent.linux-amd64 stop && \
/usr/local/cloudmonitor/CmsGoAgent.linux-amd64 uninstall && \
rm -rf /usr/local/cloudmonitor

echo "卸载阿里云盾监控......."
wget http://update.aegis.aliyun.com/download/uninstall.sh  && sh uninstall.sh
wget http://update.aegis.aliyun.com/download/quartz_uninstall.sh && sh quartz_uninstall.sh

service aegis stop #停止服务
chkconfig --del aegis # 删除服务

echo "删除残留......."
pkill aliyun-service
rm -fr /etc/init.d/agentwatch /usr/sbin/aliyun-service
rm -rf /usr/local/aegis*

echo "屏蔽阿里云盾恶意 IP......."
iptables -I INPUT -s 140.205.201.0/28 -j DROP
iptables -I INPUT -s 140.205.201.16/29 -j DROP
iptables -I INPUT -s 140.205.201.32/28 -j DROP
iptables -I INPUT -s 140.205.225.192/29 -j DROP
iptables -I INPUT -s 140.205.225.200/30 -j DROP
iptables -I INPUT -s 140.205.225.184/29 -j DROP
iptables -I INPUT -s 140.205.225.183/32 -j DROP
iptables -I INPUT -s 140.205.225.206/32 -j DROP
iptables -I INPUT -s 140.205.225.205/32 -j DROP
iptables -I INPUT -s 140.205.225.195/32 -j DROP
iptables -I INPUT -s 140.205.225.204/32 -j DROP
iptables -I INPUT -s 106.11.224.0/26 -j DROP
iptables -I INPUT -s 106.11.224.64/26 -j DROP
iptables -I INPUT -s 106.11.224.128/26 -j DROP
iptables -I INPUT -s 106.11.224.192/26 -j DROP
iptables -I INPUT -s 106.11.222.64/26 -j DROP
iptables -I INPUT -s 106.11.222.128/26 -j DROP
iptables -I INPUT -s 106.11.222.192/26 -j DROP
iptables -I INPUT -s 106.11.223.0/26 -j DROP

echo "初始化规则"
yum install iptables-services -y

echo "保存规则"
service iptables save
service iptables restart

##提示帮助
##echo -e "${red}[填写文字]${plain}"
echo -e "查看规则输入： ${red}iptables -L${plain}"
echo -e "查看进程输入： ${red}ps -U root -u${plain}"
echo -e "查看进程输入： ${red}chkconfig --list${plain}"
    echo "3. XX"
    echo "4. XX"
    echo "5. XX"
    echo "6. XX"
}





##开始菜单
start_menu(){
    
    echo "====================================================================="
    echo "	System Required: CentOS 7"
    echo "	Description: initial server"
    echo "	Version: 0.1"
    echo "	Author: sxlszzy"
    echo "	address: https://github.com/sxlszzy/Simple-Application-Server/"
    echo "====================================================================="
   echo -e "${yellow}"
    echo "1. 清理屏幕"
    echo "2. 卸载安骑士"
    echo "3. XX"
    echo "4. XX"
    echo "5. XX"
    echo "6. XX"
    echo "0. 退出脚本"
   echo -e "${plain}"
    echo
    read -p "请输入数字:" num
    case "$num" in
    	1)
	#update_kernel
	clear
	start_menu
	;;
	2)
	echo "正在. 卸载安骑士"
	clean_up
	start_menu
	;;
	3)
	#wireguard_update
	start_menu
	;;
	4)
	#wireguard_remove
	start_menu
	;;
	5)
	#content=$(cat /etc/wireguard/client.conf)
    	#echo "${content}" | qrencode -o - -t UTF8
	start_menu
	;;
	6)
	#add_user
	start_menu
	;;
	0)
	exit 1
	;;
	*)
	##clear
	echo "请输入正确数字"
	#sleep 5s
	start_menu
	;;
    esac
}
start_menu

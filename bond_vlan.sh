#!/bin/bash
#
##
echo "请选择配置模式（bond:1  bond子接口:2  删除子接口:3 请输入1,2或者3 ）"
read choose_mode
case $choose_mode in
	1)
echo "###开始配置bond###"
echo "请输入绑定的第一个网卡名字"
read interface1
echo "请输入绑定的第二个网卡名字"
read interface2
echo "请输入bond接口名称(example: bond0)"
read ifname
echo "请输入连接名称(example: bond0)"
read con_name
echo "请输入bond模式（example: balance-rr,802.3ad,active-backup,balance-alb,balance-tlb,balance-xor,broadcast）"
read mode
echo "请确认以下信息：
绑定的网卡：
$interface1 
$interface2 
bond接口名称：
$ifname 
连接名称: 
$con_name  
bond模式:
$mode
——————————————————————————————
是否开始绑定操作？
（yes or no）
——————————————————————————————"
read choose
if [ $choose != yes ];then
	echo "---不执行添加bond操作---"
	exit
else
	echo "开始执行bond操作"
	nmcli con add type bond ifname $ifname con-name $con_name mode $mode ipv4.method disabled ipv6.method ignore
	nmcli con add type bond-slave ifname $interface1 master bond0
	nmcli con add type bond-slave ifname $interface2 master bond0
	echo "---绑定完成---"
fi
nmcli con reload
;;
 	2)
echo "是否添加子接口（yes or no）"

read choose1
if [ $choose1 != yes ];then
	echo "---不执行添加子接口操作---"
	exit
else
	echo "###开始配置子接口###"
	echo "请输入连接名称（example： bond0.101）"
	read con_name1
	echo "请输入接口名称（example：bond0.101）"
	read ifname1
	echo "请输入父接口 (example: bond)"
	read dev
	echo "请输入vlan_id (exaple: 101)"
	read id
	echo "请输入子接口ip（exaple：192.168.1.100/24）"
	read ip
	echo "请输入子接口网关（example: 192.168.1.1 ）"
	read gateway
	echo "请输入dns（example: 114.114.114.114）"
	read dns
	echo "请确认以上信息：
	连接名称：
	$con_name1
	接口名称：
	$ifname1
	父接口名称：
	$dev
	vlan_id：
	$id
	ip地址；
	$ip
	网关：
	$gateway
	dns：
	$dns
	"
	nmcli con add type vlan con-name $con_name1 ifname $ifname1 dev $dev id $id ipv4.addresses $ip ipv4.gateway $gateway ipv4.dns $dns ipv6.method ignore
	echo "---子接口添加成功---"
fi
nmlic con reload
;;
	3)
echo "请输入需要删除的接口名称"
read rminterface
echo "是否删除 $rminterface 接口？(yes or no)"
read choose_rm
if [ $choose_rm != yes ];then
	echo "---不执行删除---"
	exit
else
	nmcli connection delete $rminterface
	nmcli con reload
	echo "---删除成功---"
fi	
esac

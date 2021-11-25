#!/bin/bash
#linux批量免密钥登录设置脚本
#host.txt格式为：
#IP 用户名 密码
#####
yum install expect -y
while read host;do
        ip=`echo $host | cut -d " " -f1`
        username=`echo $host | cut -d " " -f2`
        password=`echo $host | cut -d " " -f3`
expect <<EOF
        spawn ssh-copy-id -i $username@$ip
        expect {
                "yes/no" {send "yes\n";exp_continue}
                "password" {send "$password\n"}
        }
        expect eof
EOF
done < /root/host.txt

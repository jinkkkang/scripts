#!/usr/bin/bash
#修改sid,eg8100
cd /home/coovanftp/ftp/
file=($(find 8400*/ -name cqserver_conf.xml))
for i in "${file[@]}"
do
    echo $i
#修改数据库，密码
    sed -i "s/10.104.228.207/192.168.254.198/g" /home/coovanftp/ftp/$i
    sed -i "s/10.104.225.100/192.168.254.198/g" /home/coovanftp/ftp/$i
    echo "修改" $i "完毕"
done

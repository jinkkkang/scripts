#!/bin/bash
cd /home/coovanftp/ftp/
#echo -e "\033[34;1m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
FILES=($(ls | grep -v log |grep [0-9] |xargs -n1))
#FILES=($(find /home/coovanftp/ftp/ -name "cqserver_conf.xml"))
for f in "${FILES[@]}"
do
cd /home/coovanftp/ftp/${f}/
if [ -d whserver ] ; then
#当前SID目录
#$f
#游戏端口
a=$(cat /home/coovanftp/ftp/${f}/whserver/cqserver_conf.xml  | grep listener |head -n1 |awk 'NR==1 {print $4}' |cut -d \" -f 2)
#配置端口 
b=$(cat /home/coovanftp/ftp/${f}/whserver/cqserver_conf.xml |grep http_svr |awk 'NR==1 {print $3}' |cut -d \" -f 2)
#守护端口
c=$(cat /home/coovanftp/ftp/${f}/whserver/cqserver_conf.xml |grep prt_http_svr |awk 'NR==1 {print $3}'|cut -d \" -f 2)
echo "./changeport.sh" $f $a $b $c

#游戏数据库名
#cat /home/coovanftp/ftp/${f}/whserver/cqserver_conf.xml |grep cquser |awk 'NR==1 {print $2}' |cut -d \" -f 2
#日志数据库名
#cat /home/coovanftp/ftp/${f}/whserver/cqserver_conf.xml |grep cqlog |awk 'NR==1 {print $4}' |cut -d \" -f 2
#echo -e "\033[34;1m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
fi
#echo $test
done
#echo ${FILES[@]}
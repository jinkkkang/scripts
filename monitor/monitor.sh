#!/bin/bash

# author jkk
# date 17-5-31
# ver 1
# 监控服务运行状态，在发现服务未启动时启动服务，如果启动失败发送报警邮件

sleep 3
isnginx=1 #是否监控 nginx
isphp=1   #是否监控 php
ismysql=1 #是否监控 mysql
issvn=0   #是否监控svn
isrsync=1 #是否监控rsync
logfile=/root/mong.log  #监控日志
server_pro=国际美联3999 #服务器所属项目

#发送报警邮件
sendmail(){
   echo "服务器运行异常, $1 ,[$server_pro]" | mail -s "服务器系统错误"  1547182170@qq.com
}

#监控nginx
mon_ng(){
if ! netstat -lnp |grep nginx |grep 80 > /dev/null;then
    echo $(date +%Y:%m:%d:%H:%M) nginx is not running check the log >> $logfile
   /usr/local/nginx/sbin/nginx || sendmail "nginx启动失败"
fi
}

#监控php
mon_php(){ 
if ! netstat -lnp |grep php-fpm |grep 9000 > /dev/null;then
   echo $(date +%Y:%m:%d:%H:%M) php-fpm is not running check the log >> $logfile
   service php-fpm start || sendmail "PHP启动失败"
fi

 
}

#监控mysql
mon_my(){
 if ! netstat -lnp |grep mysql |grep 3306 > /dev/null;then
   echo $(date +%Y:%m:%d:%H:%M)  mysql is not running check the log >> $logfile
   service mysqld start || sendmail "MySQL启动失败"
fi
}

mon_svn(){
  if ! ps -ef |grep svnserve |grep -v grep > /dev/null;then
   echo $(date +%Y:%m:%d:%H:%M)  svn is not running check the log >> $logfile
   svnserve -d -r /usr/local/svn    || sendmail "SVN 启动失败"
fi
}

mon_rsync(){
  if ! ps -ef |grep rsync |grep -v grep > /dev/null;then
     echo $(date +%Y:%m:%d:%H:%M)  rsync is not running check the log >> $logfile
     rsync --daemon    || sendmail "rsync 启动失败"
  fi
}


if [ $isnginx -eq 1 ];then
    mon_ng
fi

if [ $isphp -eq 1 ];then
    mon_php
fi

if [ $ismysql -eq 1 ];then
    mon_my
fi

if [ $issvn -eq 1 ];then
   mon_svn
fi

if [ $isrsync -eq 1 ];then
   mon_rsync
fi
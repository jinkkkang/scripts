#!/bin/bash
# 使用方法
# 3个参数，1源城市，2目标城市 3用户
# 2个参数，源城市默认yuxi，1目标城市，2用户
# 当目标城市存在的时候进行备份。

if [ ! $2  ];then
   echo -e "\033[31;1m【 参数个数为2个或3个 】\033[0m"
   echo -e "\033[32;1m【 使用方法 】\033[0m"
   echo -e "\033[32;1m ./sh 复制区县 新建区县 开发用户 \033[0m"
   echo -e "\033[32;1m ./sh shanghai beijing  zhangsan \033[0m"
   echo -e "\033[32;1m ./sh 新建区县 开发用户 (默认复制区县为玉溪) \033[0m"
   echo -e "\033[32;1m ./sh beijing  zhangsan \033[0m"
   exit 1
fi

if [ $# -eq 3 ];then

   if [ ! `cat /etc/passwd |grep ^ $3` ];then
       echo -e "\033[31;1m【 用户 $3 不存在】\033[0m"
       exit 1
   fi
   
   if [ ! -d /home/wwwroot/$1 ];then
      echo -e "\033[31;1m【 复制区县 $1 不存在 】\033[0m"
      exit 1
   fi

   if [ -d /home/wwwroot/$2 ];then
      mv /home/wwwroot/$2 /home/wwwroot/$2_bak
      echo -e "\033[32;1m【 备份城市 $2 】\033[0m"
   fi
   cp -ar /home/wwwroot/$1 /home/wwwroot/$2
   echo -e "\033[32;1m【 新建城市 $2 】\033[0m"
   rm -rf /home/wwwroot/$2/html/*
   echo -e "\033[32;1m【 清空 $2 html 】\033[0m"
   rm -rf /home/wwwroot/$2/uploadfile/*
   echo -e "\033[32;1m【 清空 $2 uploadfile 】\033[0m"
   usermod -d /home/wwwroot/$2 $3
    if [ $? != 0 ]; then
       echo -e "\033[31;1m【 用户 $3 不存在 】\033[0m"
       exit 1
   else
      echo -e "\033[32;1m【切换用户 $3 工作目录至 /home/wwwroot/$2 】\033[0m"
   fi
fi
if [ $# -eq 2 ];then
  
   if [ ! `cat /etc/passwd |grep $2` ];then
       echo -e "\033[31;1m【 用户 $2 不存在】\033[0m"
       exit 1
   fi

   if [ -d /home/wwwroot/$1 ];then
     mv /home/wwwroot/$1 /home/wwwroot/$1_bak
     echo -e "\033[32;1m【 备份城市 $1 】\033[0m"
   fi
   cp -ar /home/wwwroot/yuxi /home/wwwroot/$1
    echo -e "\033[32;1m【 新建城市 $1 】\033[0m"
   rm -rf /home/wwwroot/$1/html/*
    echo -e "\033[32;1m【 清空 $1 html 】\033[0m"
   rm -rf /home/wwwroot/$1/uploadfile/*
    echo -e "\033[32;1m【 清空 $1 uploadfile 】\033[0m"
   usermod -d /home/wwwroot/$1 $2
   if [ $? != 0 ]; then
       echo -e "\033[31;1m【 用户 $2 不存在 】\033[0m"
       exit 1
   else
      echo -e "\033[32;1m【切换用户 $2 工作目录至 /home/wwwroot/$1 】\033[0m"
   fi
fi

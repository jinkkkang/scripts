#!/usr/bin/bash

#node.js环境的安装

ins_path=/root/env_install  #安装路径

if [ ! -d $ins_path ];then
   mkdir -p $ins_path
fi

cd $ins_path
wget https://nodejs.org/dist/v6.9.5/node-v6.9.5-linux-x64.tar.xz

if [ -f node-v6.9.5-linux-x64.tar.xz ];then
   tar xvf node-v6.9.5-linux-x64.tar.xz
else
    echo -e "\033[31;1m 【 文件下载失败 】 \033[0m"
    exit 1
fi

ln -s $ins_path/node-v6.9.5-linux-x64/bin/node /usr/local/bin/node
ln -s $ins_path/node-v6.9.5-linux-x64/bin/npm /usr/local/bin/npm

if  command -v node  >/dev/null &&  command -v npm >/dev/null 2>&1;then
	echo -e "\033[32;1m 【 安装成功,环境生效 】 \033[0m"
else
	 echo -e "\033[31;1m 【 安装失败，环境没生效 】 \033[0m"
fi

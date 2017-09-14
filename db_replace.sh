#!/usr/bin/bash

#数据库某字段内容的批量替换

#数据库用户
dbuser=root
#数据库密码
dbpd=zhongdm
#数据库库名
dbname=dmg


#判断命令是否执行成功
reback(){
if [ $? = 0 ]; then
    echo -e "\033[32;1m 【 $1 执行成功 】 \033[0m"
else
    echo -e "\033[31;1m 【 $1 执行失败 】 \033[0m"
fi
}

tables=$(mysql -u$dbuser -p$dbpd -e "use $dbname; show tables;")
for c in ${tables[@]};
do
   if [ $c != Tables_in_$dbname  ];then
      mysql -u$dbuser -p$dbpd -e "use $dbname; update $c set thumb=replace(thumb,'dmg.zhonghuass.cn','dmg.img.zhonghuass.cn') where thumb regexp '^http://dmg.zhonghuass.cn/uploadfile';"
      reback $c
   fi
done

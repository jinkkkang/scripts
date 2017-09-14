#!/usr/bin/bash

#数据库的批量恢复
#在MySQL5.6及以下版本中恢复失败的话请在5.7版本中尝试。
#此恢复方式仅适用于innodb引擎。
#将此脚本与
#(1)含有表结构的sql文件
#(2)需要恢复的城市区县的IBD文件放在一起

# 需要恢复的区县名称
city=(
download
picture
video
zhuyepage
zuixinzixun 
gerenshipin  
gerenxiangce
gerenfengcai
xiangqujulebu
huiyuanminglu
notice
datangfushi 
fujiangongcheng
datanggewu
shuhuayishu 
datangwangchao
junshijingji
mingchenxianxiang
shicigefu   
hougongpinfei   
wenxuedianji
tangdaiguanxian  
tangdaminggong   
wenhuajiaoliu
)

#数据库的存储目录，在数据库的配置文件my.cnf中[mysqld]下的datadir配置
dbpath=/usr/local/mysql/data/
#数据库用户
dbuser=root
#数据库密码
dbpd=H8s&igA
#存储恢复数据的数据库名称
#最好新建一个库用来专门存储恢复的数据
# create database  yy default character set utf8; 
dbname=gjmlxs


#判断命令是否执行成功
reback(){
if [ $? = 0 ]; then
    echo -e "\033[32;1m 【 执行成功 】 \033[0m"
else
    echo -e "\033[31;1m 【 执行失败 】 \033[0m"
    exit 1
fi
}


#判断恢复数据库所需文件是否缺失
for c in ${city[@]};
do
     mysql -u$dbuser -p$dbpd -e "use $dbname ; ALTER TABLE v9_${c} DISCARD TABLESPACE;"
		
done


# 导入表结构，并且分离表
for c in ${city[@]};
do	
	mysql -u$dbuser -p$dbpd $dbname < v9_${c}.sql
    echo -e "\033[36;1m 【 导入表 v9_${c} 结构 】 \033[0m"
	reback
	mysql -u$dbuser -p$dbpd $dbname < v9_${c}_data.sql
	echo -e "\033[36;1m 【 导入表 v9_${c}_data 结构 】 \033[0m"
	reback
    mysql -u$dbuser -p$dbpd -e "use $dbname ; ALTER TABLE v9_${c} DISCARD TABLESPACE;"
    echo -e "\033[36;1m 【 分离表 v9_${c} 】 \033[0m"
    reback
    mysql -u$dbuser -p$dbpd -e "use $dbname ; ALTER TABLE v9_${c}_data DISCARD TABLESPACE;"
    echo -e "\033[36;1m 【 分离表 v9_${c} 】 \033[0m"
    reback
done

# 将ibd文件复制到数据库目录下
cp -arf *.ibd ${dbpath}${dbname}
chmod -R 777 $dbpath

#表结构和元数据结合
for c in ${city[@]};
do	
    mysql -u$dbuser -p$dbpd -e "use $dbname ; ALTER TABLE v9_${c} IMPORT TABLESPACE;"
    echo -e "\033[36;1m 【 合成表 v9_${c} 】 \033[0m"
    reback
    mysql -u$dbuser -p$dbpd -e "use $dbname ; ALTER TABLE v9_${c}_data IMPORT TABLESPACE;"
    echo -e "\033[36;1m 【 合成表 v9_${c}_data} 】 \033[0m"
    reback
done
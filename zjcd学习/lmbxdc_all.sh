#!/bin/bash
DBHOST=127.0.0.1
DBPASS=1234561qaz9ol.
DBUSER=root
BAKNAME=bak

INNODB=(`/usr/bin/mysql -u${DBUSER} -p${DBPASS} -h${DBHOST} -s -r -e "set names utf8;show databases like 'cq%';" | grep cq`)
count=${#INNODB[*]}
function init() #初始化函数
{
	if [ -e ./dc_log.log ] ; then
		cat /dev/null > ./dc_log.log
	else
		touch ./dc_log.log
	fi
}


init
for ((i=0;i<$count;i++))
do
	echo -n 'dc '${INNODB[$i]}
mysqldump -h${DBHOST} -u$DBUSER -p$DBPASS -a -q --add-drop-table --default-character-set=utf8 --hex-blob --single-transaction -B ${INNODB[$i]} > ${INNODB[$i]}_1.sql
	if [ $? != 0 ]; then
		echo -e "\033[31;1m【FAIL】\033[0m"
		echo 'dc db fail '${INNODB[$i]} >> ./dc_log.log
	else
		echo -e "\033[32;1m【 OK 】\033[0m"
	fi
done

tar zcf $BAKNAME.tar.gz ./cq*
rm -rf *.sql
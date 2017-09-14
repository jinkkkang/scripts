#!/bin/bash
cd /home/coovanftp/ftp/
FILES=($(ls | grep -v log |grep [0-9] |xargs -n1))
#FILES=($(find /home/coovanftp/ftp/ -name "cqserver_conf.xml"))
for f in "${FILES[@]}"
do
cd /home/coovanftp/ftp/${f}/
if [ -d whserver ] ; then
	echo -n $f
	RSYNC_WH_DIR=/home/coovanftp/ftp/${f}

echo -en "\033[34;1mConfig rsync daemon config file for ${f} ... \033[0m"
if
	(cat /etc/rsyncd.conf | grep "\[${f}\]" ) > /dev/null 
then 
	echo -e "\033[35;1m【SKIP】\033[0m"
else
  cat  >>/etc/rsyncd.conf<<EOF

[${f}]
path = $RSYNC_WH_DIR
EOF
	if [ $? -eq 0 ]; then
		echo -e "\033[32;1m【 OK 】\033[0m"
	else
		echo -e "\033[31;1m【 FAIL 】 \033[0m"
	fi
fi

#echo -en "\033[34;1mConfig crontab online user for post... \033[0m"	
#if 
#	(cat /etc/crontab | grep "gmd=vn.post&sid=${f}") > /dev/null
#then
#	echo -e "\033[35;1m【SKIP】\033[0m"
#else
#	echo "*/1 * * * * root curl 'http://127.0.0.1/idxg.php?gmd=vn.post&sid=${f}' > /dev/null 2>&1" >>/etc/crontab
#	if [ $? != 0 ]; then
#		echo -e "\033[31;1m【FAIL】\033[0m"
#	else
#		echo -e "\033[32;1m【 OK 】\033[0m"
#		service crond reload > /dev/null
#	fi
#fi

echo -en "\033[34;1mConfig crontab online user ... \033[0m"	
if 
	(cat /etc/crontab | grep "gmd=collect.oluser&sid=${f}") > /dev/null
then
	echo -e "\033[35;1m【SKIP】\033[0m"
else
	echo "*/15 * * * * root curl 'http://127.0.0.1/idxg.php?gmd=collect.oluser&sid=${f}' > /dev/null 2>&1" >>/etc/crontab
	if [ $? != 0 ]; then
		echo -e "\033[31;1m【FAIL】\033[0m"
	else
		echo -e "\033[32;1m【 OK 】\033[0m"
		service crond reload > /dev/null
	fi
fi
fi
done



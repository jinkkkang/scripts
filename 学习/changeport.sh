#!/bin/bash
base=/home/coovanftp/ftp/
SID=$1
GAMESRV_GAME_PORT=$2
GAMESRV_HTTP_PORT=$3
GAMESRV_PRT_PORT=$4
if [ ! ${4} ]; then
echo './changeport.sh sid game_prot http_prot prt_prot'
echo './changeport.sh 37001 64999 8080 8081'
exit;
fi
#read -p "输入需要调整端口的sid  " SID
#echo "当前端口配置"
#echo -n "游戏端口 = "
#cat ${base}${SID}/whserver/cqserver_conf.xml |awk 'NR==25 {print $4}'|cut -c 7-11
#echo -n "配置端口 = "
#cat ${base}${SID}/whserver/cqserver_conf.xml |awk 'NR==10 {print $3}' |cut -c 7-10
#echo -n "守护端口 = "
#cat ${base}${SID}/whserver/cqserver_conf.xml |awk 'NR==11 {print $3}'|cut -c 7-10


#read -p "输入需要调整的游戏端口，或者按ctrl+C结束  " GAMESRV_GAME_PORT
#read -p "输入需要调整的配置端口，或者按ctrl+C结束  " GAMESRV_HTTP_PORT
#read -p "输入需要调整的守护端口，或者按ctrl+C结束  " GAMESRV_PRT_PORT
	 #http_service_port
	echo -en "\033[34;1m Config http_service_port ${GAMESRV_HTTP_PORT} in cqserver_conf.xml ... \033[0m" 
	sed -i "s~http_svr listen_ip=\"[^\"]*\" port=\"[^\"]*\"~http_svr listen_ip=\"127.0.0.1\" port=\"$GAMESRV_HTTP_PORT\"~" ${base}${SID}/whserver/cqserver_conf.xml
	if [ $? != 0 ]; then
		echo -e "\033[31;1m【FAIL】\033[0m" 
	else
		echo -e "\033[32;1m【 OK 】\033[0m" 
	fi
	 #prt_service_port
	echo -en "\033[34;1m Config prt_service_port ${GAMESRV_PRT_PORT} in cqserver_conf.xml ... \033[0m" 
	sed -i "s~prt_http_svr listen_ip=\"[^\"]*\" port=\"[^\"]*\"~prt_http_svr listen_ip=\"127.0.0.1\" port=\"$GAMESRV_PRT_PORT\"~" ${base}${SID}/whserver/cqserver_conf.xml
	if [ $? != 0 ]; then
		echo -e "\033[31;1m【FAIL】\033[0m" 
	else
		echo -e "\033[32;1m【 OK 】\033[0m" 
	fi
	 #game_port
	echo -en "\033[34;1m Config game_port ${GAMESRV_GAME_PORT} in cqserver_conf.xml ...\033[0m" 
	sed -i "/<conn_server>/,/<\/conn_server>/s~listener type=\"tcp\" address=\"0\" port=\"[^\"]*\"~listener type=\"tcp\" address=\"0\" port=\"$GAMESRV_GAME_PORT\"~" ${base}${SID}/whserver/cqserver_conf.xml
	if [ $? != 0 ]; then
		echo -e "\033[31;1m【FAIL】\033[0m" 
	else
		echo -e "\033[32;1m【 OK 】\033[0m" 
	fi
		echo -e "\033[34;1mConfig iptables for gamesrv's game_port ${GAMESRV_GAME_PORT} ... \033[0m" 
	echo -en "\033[34;1m    Config iptables for gameserver game_port in (/etc/sysconfig/iptables) ... \033[0m" 
	if
		(cat /etc/sysconfig/iptables | grep " ${GAMESRV_GAME_PORT} -j" ) > /dev/null
	then 
		echo -e "gamesrv's game_port is configed on iptables !\033[35;1m【SKIP】\033[0m" 
	else
		sed -i "/-A RH-Firewall-1-INPUT -j REJECT --reject-with icmp-host-prohibited/i\-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport ${GAMESRV_GAME_PORT} -j ACCEPT" /etc/sysconfig/iptables 
		if [ $? != 0 ]; then
			echo -e "\033[31;1m【FAIL】\033[0m" 
		else
			echo -e "\033[32;1m【 OK 】\033[0m" 
			/etc/init.d/iptables restart > /dev/null
		fi
	fi
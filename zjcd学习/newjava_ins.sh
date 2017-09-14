#!/bin/bash
# author Orz
scriptVer=1.0.6

###### constants
# get file name
ScriptSelfName=$(echo $0)
# get install path
ScriptSelfPath=$(cd "$(dirname "$0")"; pwd)
# log file name and path
logFile=$ScriptSelfPath/javainstall_log.log
# script path
theFiledir=$ScriptSelfPath
# some file name
sumFile="md5.txt"
defFileName="javaPackage.zip"
# install tmp source dir
sourceDir=/home/install
# username
userName=jsmt
# usergroup
userGroup=jsmt
#######

# init install scpipt
function init()
{
        if [[ $(getconf LONG_BIT) != 64 ]]; then
            echo -e "\033[31;1mWe should use the 64bit system,check the system when you install env! \033[0m"
            exit 1
        fi
        echo
        if [ ! -f ${defFileName} ]; then
            echo -e "\033[31;1mCan't Find Package ${defFileName} \033[0m"
            echo -en "\033[34;1mDownLoad the Package : ${defFileName} ... \033[0m" | tee -a ${logFile}
            wget -q -c http://zabbix.8090mt.com/install/Java/${defFileName}
            ForS $? 1
        fi
}

function unzipPackage()
{
        echo
        echo -en "\033[34;1mUnzip package ... \033[0m" | tee -a ${logFile}
        if [ -e ${sourceDir} ]; then
            \cp ${defFileName} ${sourceDir}
            cd ${sourceDir}
            unzip -o ${defFileName} >> ${logFile} 2>&1
        else
            mkdir -p ${sourceDir}
            \cp ${defFileName} ${sourceDir}
            cd ${sourceDir}
            unzip -o ${defFileName} >> ${logFile} 2>&1
        fi
        ForS $? 1
}

# get false or success
function ForS()
{
        if [ $1 -eq 0 ]; then
            echo -e "\033[32;1m【 OK 】\033[0m" | tee -a ${logFile}
        else
            echo -e "\033[31;1m【 FAIL 】 \033[0m" | tee -a ${logFile}
            if [ $2 ]; then
                exit 1
            fi
        fi
}

function setSysctl()
{
    Confs=$1
    fileName=$2
    for (( i = 0; i < ${#Confs[@]}; i++ )); do
        status=$(sed -n "/${Confs[$i]}/p" ${fileName})
        if [ ! ${status} ]; then
            echo ${Confs[$i]} >> ${fileName}
        else
            echo -n "${Confs[$i]} is exist!!!" |tee -a ${logFile}
            skip
        fi
    done
}

#  echo skip
function skip()
{
        echo -e "\033[35;1m【SKIP】\033[0m" | tee -a ${logFile}
}

# check package file md5
function checkFiles()
{
        echo
        echo -en "\033[34;1mCheck Files ... \033[0m" | tee -a ${logFile}
        cd ${sourceDir}
        File=($(cat ${sumFile} | xargs -n1))
        for (( i=0; i < ${#File[@]}; i+=2 )); do
            md5=$(md5sum ${File[($i+1)]} | awk {'print $1'})
            if [ ${md5} != ${File[$i]} ]; then
                echo -e "\033[31;1mCheck file : "${File[$i + 1]}" is FAIL, Please check the source file! \033[0m" | tee -a ${logFile}
                exit 1
            fi
        done
        ForS $?
}

# GCC Group
function dependInsatll()
{
        echo
        echo -en "\033[34;1mYum Install GCC Group and Tools ... \033[0m" | tee -a ${logFile}
        yum -y install iptables gcc gcc-c++ wget vim-enhanced openssl openssl-devel zip unzip lsof iotop iftop curl>> ${logFile} 2>&1
        ForS $?
}

# timezone setting Los Angeles
function changeTimeZone()
{
        echo
        echo -en "\033[34;1mset TimeZone ... \033[0m" | tee -a ${logFile}
        \cp -f /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
        kwclock
        echo ZONE='"America/Los_Angeles"' > /etc/sysconfig/clock
        echo  UTC=false >> /etc/sysconfig/clock
        echo  ARC=false >> /etc/sysconfig/clock
        #date -R
        ForS $?
}

# i18n
function changeI18n()
{
        echo
        echo -en "\033[34;1mset i18n ... \033[0m" | tee -a ${logFile}
        echo 'SYSFONT="latarcyrheb-sun16"' >> /etc/sysconfig/i18n
        source /etc/sysconfig/i18n
        ForS $?
}

# set unlimit 60000
function setUlimit()
{
        echo
        echo -en "\033[34;1mset Ulimit ... \033[0m" | tee -a ${logFile}
        ulimit -n 60000
        ulimit -u  unlimited
        ulimit -d  unlimited
        ulimit -m  unlimited
        ulimit -s  unlimited
        ulimit -t  unlimited
        ulimit -v  unlimited
        echo '*      soft    nofile     60000' >> /etc/security/limits.conf
        echo '*      hard    nofile     60000' >> /etc/security/limits.conf
        ForS $?
}


# Optimization system
function systemOptimize()
{
        echo
        echo -en "\033[34;1mOptimization system ... \033[0m" | tee -a ${logFile}
        #系统参数优化
        Confs=(
        'net.ipv4.ip_local_port_range=1024 65535'
        'net.core.rmem_default=124928'
        'net.core.wmem_default=124928'
        'net.core.rmem_max=16777216'
        'net.core.wmem_max=16777216'
        'net.core.somaxconn=2048'
        'net.core.netdev_max_backlog=2000'
        'net.core.optmem_max=81920'
        'net.ipv4.tcp_mem=131072 262144 524288'
        'net.ipv4.tcp_rmem=4096 87380 16777216'
        'net.ipv4.tcp_wmem=4096 65536 16777216'
        'net.ipv4.tcp_fin_timeout=10'
        'net.ipv4.tcp_tw_recycle=1'
        'net.ipv4.tcp_tw_reuse=1'
        'net.ipv4.tcp_timestamps=1'
        'net.ipv4.tcp_window_scaling=0'
        'net.ipv4.tcp_sack=1'
        'net.ipv4.tcp_fack=1'
        'net.ipv4.tcp_no_metrics_save=1'
        'net.ipv4.tcp_syncookies=1'
        'net.ipv4.tcp_max_orphans=262144'
        'net.ipv4.tcp_max_syn_backlog=262144'
        'net.ipv4.tcp_synack_retries=2'
        'net.ipv4.tcp_syn_retries=2'
        'net.ipv4.tcp_keepalive_time=1800'
        'net.ipv4.tcp_keepalive_intvl=20'
        'net.ipv4.tcp_keepalive_probes=3'
        'net.ipv4.tcp_low_latency=0'
        )
        setSysctl $Confs '/etc/sysctl.conf'
        sysctl -p >> ${logFile} 2>&1
        ForS $?
        echo -en "\033[34;1mConfig System Services ... \033[0m" | tee -a ${logFile}
            pServers=(acpid atd auditd haldaemon ip6tables lvm2-monitor mdmonitor messagebus netfs restorecond postfix smartd)
            for ((i=0;i<${#pServers[*]};i++))
            do
                echo -en "\033[34;1m    Stop ${pServers[$i]} ... \033[0m" | tee -a ${logFile}
                service ${pServers[$i]} stop > /dev/null
            	chkconfig ${pServers[$i]} --level 345 off  > /dev/null
                ForS $?
            done
        echo -en "\033[34;1mConfig System Limits ... \033[0m" | tee -a ${logFile}
        if
                (cat /etc/security/limits.conf | grep '* hard stack 524288') 1>/dev/null
        then
                skip
        else
                echo -ne "
                    * soft nofile 655360
                    * hard nofile 655360
                    * soft core 20971520
                    * hard core 20971520
                    * soft stack 524288
                    * hard stack 524288
                " >> /etc/security/limits.conf
                ForS $?
        fi
        echo
        echo -en "\033[34;1mOptimization system other ... \033[0m" | tee -a ${logFile}
        Confs=(
            'net.nf_conntrack_max=10240'
            'net.ipv4.tcp_westwood=0'
            'net.ipv4.tcp_bic=1'
        )
        setSysctl $Confs '/etc/sysctl.conf'
        sysctl -p >> ${logFile} 2>&1    #因低版本的操作系统不支持后面三个参数，故放置最后执行，且不报错
        ForS $?
        # mkdir -p /data/bash
        # mkdir -p /data/update/gs
}

# install mysql
function installMysqlClient()
{
        echo
        echo -en "\033[34;1mYum install MySql ... \033[0m" | tee -a ${logFile}
        yum -y install mysql mysql-server mysql-devel >> ${logFile} 2>&1
        ForS $?

}

# install java1.8.0.111
function javaInstall()
{
        echo
        echo -en "\033[34;1mInstall Java ... \033[0m" | tee -a ${logFile}
        cd ${sourceDir}
        rpm -qa|grep java | xargs -n1 rpm -e --nodeps >> ${logFile} 2>&1
        mkdir -p /usr/local/java
        if [ -f jdk-8u111-linux-x64.tar.gz ]; then
                cp jdk-8u111-linux-x64.tar.gz /usr/local/java/
        else
                wget http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz
                cp jdk-8u111-linux-x64.tar.gz /usr/local/java/
        fi
        cd /usr/local/java
        tar zxvf jdk-8u111-linux-x64.tar.gz >> ${logFile} 2>&1
        ForS $?
        rm -f jdk-8u111-linux-x64.tar.gz
        echo
        echo -en "\033[34;1mSetting Java Env ... \033[0m" | tee -a ${logFile}
        if [ $(cat /etc/profile | grep jdk1.8.0_111) ]; then
          skip
        else
          echo 'JAVA_HOME=/usr/local/java/jdk1.8.0_111' >> /etc/profile
          echo 'JRE_HOME=$JAVA_HOME/jre' >> /etc/profile
          echo 'PATH=$PATH:$JAVA_HOME/bin:\$JRE_HOME/bin' >> /etc/profile
          echo 'CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:$JRE_HOME/lib' >> /etc/profile
          echo 'export JAVA_HOME JRE_HOME PATH CLASSPATH' >> /etc/profile
          source /etc/profile >> ${logFile} 2>&1
          ForS $?
        fi
        cd ${theFiledir}
        # 获取进程cpu占用
        cat >/usr/bin/getCPU<<EOF
#!/usr/bin/env bash
if [[ $1 ]]; then
    ps aux | grep java | grep $1 | awk '{print $3}'
fi
EOF
        chmod 755 /usr/bin/getCPU
}

# install pcre
function pcreInstall()
{
        echo
        echo -en "\033[34;1mInstall Pcre ... \033[0m" | tee -a ${logFile}
        cd ${sourceDir}
        tar zxvf pcre-8.12.tar.gz  >> ${logFile} 2>&1
        cd ./pcre-8.12/
        ./configure >> ${logFile} 2>&1
        make >> ${logFile} 2>&1
        make install >> ${logFile} 2>&1
        ForS $?
}

# install nginx
function nginxInstall()
{
        echo
        echo -en "\033[34;1mAdd user ${userName} and group ${userGroup} ... \033[0m" | tee -a ${logFile}
        groupadd ${userGroup}
        useradd -g ${userGroup} ${userName}
        ForS $?
        echo
        echo -en "\033[34;1mInstall Nginx ... \033[0m" | tee -a ${logFile}
        cd ${sourceDir}
        tar zxvf nginx-1.0.15.tar.gz >> ${logFile} 2>&1
        cd nginx-1.0.15
        ./configure \
        --prefix=/usr/local/nginx \
        --sbin-path=/usr/bin/nginx \
        --error-log-path=/var/log/nginx \
        --conf-path=/usr/local/nginx/nginx.conf \
        --pid-path=/var/run/nginx.pid \
        --with-pcre \
        --user=${userName} \
        --group=${userGroup} \
        --with-http_stub_status_module \
        --with-http_ssl_module >> ${logFile} 2>&1
        make -j4 >> ${logFile} 2>&1
        make install >> ${logFile} 2>&1
        ForS $?
        cd ${sourceDir}
        \cp nginx /etc/init.d/nginx
        chmod 755 /etc/init.d/nginx
        cat >/usr/local/nginx/nginx.conf<<EOF
user  ${userName} ${userGroup};
worker_processes  4;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    #tcp_nopush     on;
    #keepalive_timeout  0;
    keepalive_timeout  65;
    gzip  on;
    server {
        listen       80;
        server_name  localhost;
        charset utf-8;
        #access_log  logs/host.access.log  main;
        location / {
            root   /home/${userName}/apps;
            index  index.html index.htm;
        }
    }
    # HTTPS server
    #
    #server {
    #    listen       443;
    #    server_name  localhost;
    #    ssl                  on;
    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;
    #    ssl_session_timeout  5m;
    #    ssl_protocols  SSLv2 SSLv3 TLSv1;
    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers   on;
    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
}

EOF
        /etc/init.d/nginx start
        mkdir -p /home/${userName}/apps
        touch /home/${userName}/apps/index.html
        echo '<h1>test</h1>' >> /home/${userName}/apps/index.html
}

tomcatInstall(){
        echo -en "\033[34;1mInstall TomCat ... \033[0m" | tee -a ${logFile}
        unzip -o apache-tomcat-6.0.48.zip -d /usr/local >> ${logFile} 2>&1
        source /etc/profile >> ${logFile} 2>&1
        if [ $(cat /etc/profile | grep apache-tomcat-6.0.48) ]; then
          skip
        else
          echo 'TOMCAT_HOME=/usr/local/apache-tomcat-6.0.48' >> /etc/profile
          echo 'PATH=$PATH:$TOMCAT_HOME/bin' >> /etc/profile
          echo 'export TOMCAT_HOME PATH' >> /etc/profile
          source /etc/profile >> ${logFile} 2>&1
          ForS $?
        fi
}

# main init server
function mainInit()
{
        init
        dependInsatll
        unzipPackage
        checkFiles
}

function installJDK() {
        javaInstall
        setUlimit
        systemOptimize
}

# main nginx
function mainNginx()
{
        pcreInstall
        nginxInstall
}

# help
function printHelp()
{
        echo -e "\033[34;1musage "${ScriptSelfName}" (-init[-i]/-nginx[-n])\033[0m"
        echo -e "\033[34;1m-init[-i]   : install java and mysql\033[0m"
        echo -e "\033[34;1m-nginx[-n]  : install nginx\033[0m"
        echo -e "\033[34;1m-tomcat[-t] : install tomcat\033[0m"
        echo -e "\033[34;1mver         : "${scriptVer}"\033[0m"
}

case $1 in
    -init|-i )
        mainInit
        installJDK
        installMysqlClient
        java -version
        echo
        echo
        echo "relogin"
        echo
        ;;
    -nginx|-n )
        mainInit
        mainNginx
        lsof -i:80
        ;;
    -tomcat|-t)
        mainInit
        tomcatInstall
        ;;
    -help|-h)
        printHelp
        ;;
     * )
        printf "usage %s (-init[-i]/-nginx[-n] or -t/-tomcat or -h/-help) \n\tver:%s\n" ${ScriptSelfName} ${scriptVer}
        ;;
esac

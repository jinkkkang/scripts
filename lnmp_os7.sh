#!/usr/bin/bash
#Centos 7 
# MySQL & Nginx & PHP & memcached & SVN
# author jkk
 


install_env=1 #是否安装环境依赖(服务器初次环境安装时建议选择此项)

#********MySQL**************
install_mysql=0 #是否安装mysql
mypasspd='H8s&igA'  #数据库root密码,如果不安装mysql,此项可忽略
sql_up=1 # 是否优化数据库配置

#********Nginx*********************
install_nginx=1   #是否安装nginx

#********PHP**************************
install_php=1     # 是否安装php，默认扩展pdo_mysql
extend_yaf=0      #是否安装 yaf扩展
dir_yaconf=/yaconf  #yaconf配置目录
extend_memcached=0  #是否安装 memcached扩展
extend_redis=0 # 是否安装 redis扩展
swoole_kuozhan=0 #是否安装swoole扩展

install_iptables=0  # 是否安装 iptables 服务

install_memcached=0 #是否安装memcached
install_redis=0 #是否安装redis

#***********SVN******************
install_svn=0  #是否安装SVN
#svn相关配置
dir_svn=/home/svn #svn项目目录
pro_svn=ssgh  # svn项目名称
dir_update=/home/wwwroot  #svn项目同步更新路径
svn_user=admin #svn默认账户名(可在项目文件下的./conf/passwd下进行添加)
svn_passwd=123456 # svn默认用户名admin的密码

is_mon=1 #是否配置监控脚本

path=$(pwd)

ins_log=$path/ins.log #安装日志

start_time=$(date +%s)  # 获取开始时间戳

die(){
  echo ERROR $1 >> $ins_log
  exit 1
}

#检测是否是root用户运行
if [ "$(id -u)" -ne 0 ] ; then
        echo "You must run this script as root. Sorry!"
        exit 1
fi

# 安装环境依赖
if [ $install_env -eq 1 ];then
    yum -y install wget zip zlib zlib-devel openssl openssl-devel* pcre pcre-devel  autoconf automake    gcc-c++ ncurses-devel
    yum -y install bzip2  gcc make gd-devel libjpeg-devel libpng-devel libxml2-devel bzip2-devel libcurl-devel sysstat
fi



#安装数据库
myins(){
wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm || die "download mysql failed"
 rpm -ivh mysql-community-release-el7-5.noarch.rpm
 yum -y install mysql mysql-devel mysql-server ||  die "install mysql failed" 
cat >/etc/my.cnf<<EOF
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
key_buffer_size = 384M
max_allowed_packet = 100M
table_open_cache = 512
sort_buffer_size = 40M
read_buffer_size = 40M
read_rnd_buffer_size = 80M
myisam_sort_buffer_size = 200M
thread_cache_size = 20
query_cache_size = 100M

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

EOF

service mysqld start
if [ $? = 0 ]; then
    mysqladmin -u root password $mypasspd
    echo -e "\033[32;1m 【 MySQL password setup OK 】 \033[0m"
else
    echo -e "\033[31;1m start mysql failed   \033[0m"
fi
chkconfig mysqld on
service mysqld restart 

echo "mysql install finshed" >>  $ins_log
}

yaf_ins(){
    cd $path
    wget http://pecl.php.net/get/yaf-3.0.4.tgz || die "download yaf file failed"
    tar -zxvf yaf-3.0.4.tgz
    cd  yaf-3.0.4
    /usr/local/php/bin/phpize
    ./configure --with-php-config=/usr/local/php/bin/php-config
    make && make install  
    if [ $? = 0 ]; then
        echo "extension=yaf.so" >> /usr/local/php/etc/php.ini
    else
        echo -e "\033[31;1m 【ext the  php module yaf FAIL】\033[0m" 
        die "install yaf failed"
    fi  

    cd $path
    wget http://pecl.php.net/get/yaconf-1.0.2.tgz || die "download yaconf failed"
    tar -zxvf yaconf-1.0.2.tgz
    cd  yaconf-1.0.2
    /usr/local/php/bin/phpize
    ./configure --with-php-config=/usr/local/php/bin/php-config
    make && make install  
    if [ $? = 0 ]; then
        echo "extension=yaconf.so" >> /usr/local/php/etc/php.ini
        echo "yaconf.directory=/tmp/yaconf/" >> /usr/local/php/etc/php.ini
        mkdir -p  $dir_yaconf 
    else
        echo -e "\033[31;1m 【ext the  php module yaconf FAIL】\033[0m" 
        die "install yaconf failed"
    fi  
}

#redis扩展函数
redis_ins(){
    cd $path
    wget http://pecl.php.net/get/redis-3.1.2.tgz ||  die "download redis  failed"
    tar -zxvf  redis-3.1.2.tgz
    cd redis-3.1.2
    /usr/local/php/bin/phpize
    ./configure --with-php-config=/usr/local/php/bin/php-config
    make && make install 
    if [ $? = 0 ]; then
        echo "extension=redis.so" >> /usr/local/php/etc/php.ini
    else
        echo -e "\033[31;1m 【ext the  php module REDIS FAIL】\033[0m"
        die "extend redis  failed"
    fi  
}

swoole_ins(){
    cd $path
    wget http://pecl.php.net/get/swoole-1.9.14.tgz || die "download swoole  failed"
    tar -zxvf swoole-1.9.14.tgz
    cd swoole-1.9.14
    /usr/local/php/bin/phpize
    ./configure --with-php-config=/usr/local/php/bin/php-config
    make && make install
    if [ $? = 0 ]; then
        echo "extension=swoole.so" >> /usr/local/php/etc/php.ini
    else
        echo -e "\033[31;1m 【ext the  php module REDIS FAIL】\033[0m" 
        die "extend swoole  failed"
    fi  
}

memcached_ins(){
    cd $path
    wget  https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz || die "download libmemcached  failed"
    tar -zxvf libmemcached-1.0.18.tar.gz
    cd libmemcached-1.0.18
    ./configure --prefix=/usr/local/libmemcached --with-memcached
    make && make install || die "extend memcached failed"

    cd $path
    wget http://pecl.php.net/get/memcached-3.0.3.tgz || die "download  memcached failed"
    tar -zxvf memcached-3.0.3.tgz
    cd memcached-3.0.3
    /usr/local/php7/bin/phpize
    ./configure --with-php-config=/usr/local/php/bin/php-config   --with-libmemcached-dir=/usr/local/libmemcached
    make && make install  || die "extend  memcached failed"
}


red_ins(){
    cd $path
    wget http://download.redis.io/releases/redis-3.2.9.tar.gz ||  die "download  redis failed"
    tar -zxvf redis-3.2.9.tar.gz
    cd redis-3.2.9
    make || die "install the redis server failed"
}

phpins(){
cd $path
groupadd www && useradd www -g www
wget http://mirrors.sohu.com/php/php-7.1.3.tar.gz || die "download php file failed"
  tar -zxvf php-7.1.3.tar.gz
  cd php-7.1.3
    ./configure \
    --prefix=/usr/local/php \
    --with-config-file-path=/usr/local/php/etc \
    --enable-fpm \
    --enable-ftp \
    --with-fpm-user=www \
    --with-fpm-group=www \
    --enable-inline-optimization \
    --enable-sockets \
    \
    --enable-mbstring \
    --enable-mbregex \
    \
    --enable-xml \
    --with-libxml-dir=/usr/include/libxml2/libxml \
    --enable-zip \
    --with-zlib \
    --with-curl \
    \
    --with-freetype-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-gd \
    --enable-gd-native-ttf \
    \
    --with-iconv-dir \
    --with-openssl \
    \
   --with-mysqli=mysqlnd  \
   --with-mysql=mysqlnd \
   --with-libdir=lib64 > /dev/null
   make  && make install || die "install php failed"
     cp php.ini-development  /usr/local/php/etc/php.ini
     cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
     cp ./sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
     cp /usr/local/php/etc/php-fpm.d/www.conf.default  /usr/local/php/etc/php-fpm.d/www.conf
     chmod a+x /etc/init.d/php-fpm
     chkconfig  php-fpm on
    #php模板扩展
     cd $path/php-7.*/ext/pdo_mysql/
    /usr/local/php/bin/phpize
    ./configure --with-php-config=/usr/local/php/bin/php-config
    make && make install || die "ext the  php module pdo_mysql FAIL"
    echo "extension=pdo_mysql.so" >> /usr/local/php/etc/php.ini

    if [ $extend_yaf -eq 1 ];then
         yaf_ins
    fi

    if [ $extend_memcached -eq 1 ];then
        memcached_ins
    fi

    if [ $extend_redis -eq 1 ];then
        redis_ins
    fi

    if [ $swoole_kuozhan -eq 1];then
        swoole_ins
    fi
    # php 配置优化
    sed -i "s/pm.max_children = 5/pm.max_children = 100/"  /usr/local/php/etc/php-fpm.d/www.conf
    sed -i "s/pm.start_servers = 2/pm.start_servers = 20/"  /usr/local/php/etc/php-fpm.d/www.conf
    sed -i "s/pm.min_spare_servers = 1/pm.min_spare_servers = 10/"  /usr/local/php/etc/php-fpm.d/www.conf
    sed -i "s/pm.max_spare_servers = 3/pm.max_spare_servers = 50/"  /usr/local/php/etc/php-fpm.d/www.conf
    sed -i "s/;date.timezone =/date.timezone = Asia\/Shanghai/"  /usr/local/php/etc/php.ini
    service php-fpm restart || die "restart php-fpm failed"
    echo php install finshed >>  $ins_log
}
ngins(){
cd $path
wget http://mirrors.sohu.com/nginx/nginx-1.6.2.tar.gz || die "download nginx failed"
tar -zxvf nginx-1.6.2.tar.gz
cd nginx-1.6.2
./configure --prefix=/usr/local/nginx >/dev/null
make && make install  || die "install nginx failed"
cat >/etc/init.d/nginx<<EOF
#! /bin/sh
# chkconfig: 2345 55 25
# Description: Startup script for nginx webserver on Debian. Place in /etc/init.d and
# run 'update-rc.d -f nginx defaults', or use the appropriate command on your
# distro. For CentOS/Redhat run: 'chkconfig --add nginx'

### BEGIN INIT INFO
# Provides:          nginx
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the nginx web server
# Description:       starts nginx using start-stop-daemon
### END INIT INFO

# Author:   licess
# website:  http://lnmp.org

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
NAME=nginx
NGINX_BIN=/usr/local/nginx/sbin/\$NAME
CONFIGFILE=/usr/local/nginx/conf/\$NAME.conf
PIDFILE=/usr/local/nginx/logs/\$NAME.pid

case "\$1" in
    start)
        echo -n "Starting \$NAME... "

        if netstat -tnpl | grep -q nginx;then
            echo "\$NAME (pid `pidof \$NAME`) already running."
            exit 1
        fi

        \$NGINX_BIN -c \$CONFIGFILE

        if [ "\$?" != 0 ] ; then
            echo " failed"
            exit 1
        else
            echo " done"
        fi
        ;;

    stop)
        echo -n "Stoping \$NAME... "

        if ! netstat -tnpl | grep -q nginx; then
            echo "\$NAME is not running."
            exit 1
        fi

        \$NGINX_BIN -s stop

        if [ "\$?" != 0 ] ; then
            echo " failed. Use force-quit"
            exit 1
        else
            echo " done"
        fi
        ;;

    status)
        if netstat -tnpl | grep -q nginx; then
            PID=\$(pidof nginx)
            echo "\$NAME (pid $PID) is running..."
        else
            echo "\$NAME is stopped"
            exit 0
        fi
        ;;

    force-quit)
        echo -n "Terminating \$NAME... "

        if ! netstat -tnpl | grep -q nginx; then
            echo "\$NAME is not running."
            exit 1
        fi

        kill `pidof \$NAME`

        if [ "\$?" != 0 ] ; then
            echo " failed"
            exit 1
        else
            echo " done"
        fi
        ;;

    restart)
        \$0 stop
        sleep 1
        \$0 start
        ;;

    reload)
        echo -n "Reload service \$NAME... "

        if netstat -tnpl | grep -q nginx; then
            \$NGINX_BIN -s reload
            echo " done"
        else
            echo "\$NAME is not running, can't reload."
            exit 1
        fi
        ;;

    configtest)
        echo -n "Test \$NAME configure files... "

        \$NGINX_BIN -t
        ;;

    *)
        echo "Usage: \$0 {start|stop|force-quit|restart|reload|status|configtest}"
        exit 1
        ;;

esac

EOF
chmod a+x /etc/init.d/nginx
rm -rf /usr/local/nginx/conf/ngin.conf
rm -rf /usr/local/nginx/conf/vhost && mkdir -p /usr/local/nginx/conf/vhost
cp $path/nginx/nginx.conf  /usr/local/nginx/conf/ngin.conf
cp $path/nginx/vhost.conf  /usr/local/nginx/conf/vhost/vhost.conf
mkdir -p /home/wwwlogs
mkdir -p /home/wwwroot
service nginx start 
chkconfig  nginx on
}

ipins(){
  yum -y install iptables-services 
}

svnins(){
if [ "`yum list installed |grep subversion`"  ];then
         echo -e "\033[32;1m【 SVN HAVE INSTALLED 】\033[0m"
else
     yum -y install subversion
     if [ $? != 0 ]; then
        echo -e "\033[31;1m 【INSTALL SVN  FAIL】\033[0m"
     exit 1
     fi
fi
if [ -d $dir_svn ];then
    cd  $dir_svn
else
    mkdir $dir_svn
    cd $dir_svn
fi
svnadmin create $pro_svn || die "Create SVN project FAIL"
cat >./${pro_svn}/conf/passwd<<EOF
[users]
${svn_user} = ${svn_passwd}
EOF

echo "
[/]
* = rw
" > ./${pro_svn}/conf/authz

echo "
[general]
anon-access = none
auth-access = write
password-db = passwd
" > ./${pro_svn}/conf/svnserve.conf

######
cat >./${pro_svn}/hooks/post-commit<<EOF
#!/bin/sh
export LC_CTYPE="zh_CN.UTF-8"
SVN=/usr/bin/svn
TODIR=${dir_update}
\$SVN update –username ${svn_user} –password ${svn_passwd} \$TODIR
EOF

chmod a+x ./${pro_svn}/hooks/post-commit


#检测svn服务是否开启
if [ "`netstat -anp |grep svnserve`"  ];then
        echo -e "\033[35;1m【 SVN service is running 】\033[0m"
   else
        echo -e "\033[32;1m【 Start the SVN service 】\033[0m"
        svnserve -d -r ${dir_svn} || die "SVN START FAILE"
fi

#将 svn设置为开机自启动
echo svnserve -d -r ${dir_svn}  >> /etc/rc.d/rc.local
chmod a+x  /etc/rc.d/rc.local
 }

mon(){

cd $path
cp monitor.sh  /usr/bin/monitor.sh || die "monitor file not exist"
chmod a+x  /usr/bin/monitor.sh
echo  "*  *  *  *  *  root  /usr/bin/monitor.sh" >> /etc/crontab
service crond restart

}

mem_ins(){

yum install libevent libevent-deve  memcached  -y
memcached -d -u root -m 1024M -p 11211 || die "memcached install failed"
# 将memcached 设置为开机自启动
echo memcached -d -u root -m 1024M -p 11211 >> /etc/rc.d/rc.local
chmod a+x /etc/rc.d/rc.local

}



# 安装数据库
if [ $install_mysql -eq 1 ];then
    myins
fi

# 安装php
if [ $install_php -eq 1 ];then
    phpins
fi 

# 安装nginx
if [ $install_nginx -eq 1 ];then
    ngins
fi

#安装iptables 服务
if [ $install_iptables -eq 1 ];then
    ipins
fi

# 安装svn
if [ $install_svn -eq 1 ];then
    svnins
fi

#配置服务监控脚本
if [ $is_mon -eq 1 ];then
    mon
fi

#安装 memcached
if [ $install_memcached -eq 1 ];then
     mem_ins
fi

#安装redis
if [ $install_redis -eq 1 ];then
     red_ins
fi

end_time=$(date +%s)  # 获取结束时间戳
take_time=$(expr $end_time - $start_time) #安装时间
echo -e "\033[32;1m  INSTALL FINISHED \033[0m" 
echo -e "\033[32;1m  INSTALL TAKE TIME $take_time  SENCOND \033[0m" 
echo take time $take_time >>  $ins_log
exit 0
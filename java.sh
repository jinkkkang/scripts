#!/bin/bash
#java&tomcat 环境安装
#author jkk


ins_dir=/usr/local/java
ins_log=/usr/local/java/ins.log


die(){
  echo ERROR $1 >> $ins_log
  exit 1
}

if [ ! -d $ins_dir ];then
   mkdir -p  $ins_dir
fi

java_ins(){
	if command -v java >/dev/null; then
		echo "java 已经安装" | tee -a $ins_log 
		exit 1
	fi
	cd $ins_dir
	wget http://47.93.158.182/jdk1.7.0_25.tar.gz  || die "下载java包失败"
	tar -zxvf jdk1.7.0_25.tar.gz
	echo "JAVA_HOME=$ins_dir/jdk1.7.0_25"  >>  /etc/profile
	echo 'JRE_HOME=$JAVA_HOME/jre'  >>  /etc/profile
	echo 'PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin' >> /etc/profile
	echo 'CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib'  >>  /etc/profile
	echo 'export JAVA_HOME JRE_HOME PATH CLASSPATH'  >>  /etc/profile

    source  /etc/profile
	if command -v java >/dev/null; then
		echo "java 安装成功" | tee -a $ins_log 
	fi
	 

}

java_ins
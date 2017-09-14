#!/usr/bin/bash
# clean log file 

log_path=/home/wwwlog
log_clean=/root/clean.log


outlog(){
  echo  $(date +%Y%m%d) $1 >> $log_clean
  exit 1
}

if [ ! -d $log_path ];then
   outlog "the log dir is not exist"
   exit
fi

for log in $(ls $log_path);
do      
    if [ -d  $log_path/$log ];then
        cd  $log_path/$log
		tar -zcvf   access_$(date +%Y%m%d).tar.gz  access.log ||  outlog "backup $log failed"
		> $log_path/$log/access.log
    fi

done
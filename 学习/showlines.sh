#!/bin/bash
cd /home/coovanftp/ftp/
echo -e "\033[34;1m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
FILES=($(ls | grep -v log |grep [0-9] |xargs -n1))
#FILES=($(find /home/coovanftp/ftp/ -name "cqserver_conf.xml"))
for f in "${FILES[@]}"
do
cd /home/coovanftp/ftp/${f}/
if [ -d whserver ] ; then
        cqxml=/home/coovanftp/ftp/${f}/whserver/cqserver_conf.xml
        world_service='<world_service\ main_script='
        xmlcount=`cat $cqxml | grep '<world_service main_script="scripts/world_service.cs" thread_count="2" exit_wait="600" tick_time="333"></world_service>' | wc -l` #查看当前配置线路
        echo "$f world_service num: "$xmlcount       
echo -e "\033[34;1m━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
fi
#echo $test
done

#echo ${FILES[@]}

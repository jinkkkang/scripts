#!/bin/bash
# 大明宫测试往线上同步
# 在file内写上需要同步的文件的绝对路径，一行一个
file=(
/phpcms/templates/default/member/register.html
/phpcms/templates/default/member/wap_register.html
)
for f in ${file[@]};
do
   if [ ! -f  /home/wwwroot/dmg$f  ];then
     echo $f not exist
   fi
   rsync  -aSz /home/wwwroot/dmg$f rsync://zhong@10.30.55.153/dmg$f  --password-file=/etc/rsyncd.secrets
done

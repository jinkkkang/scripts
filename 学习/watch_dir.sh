#!/bin/bash
#商贸后台添加的图片及时提交到版本库中

#监控目录
src=/home/wwwroot/sssm/Api/upload

inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w%f' -e close_write,delete,create,attrib $src | while read file
do
     cd $src
     svn add *
     svn commit -m "add img" > /dev/null
     echo commit imgage to svn $(date) >> /home/wwwlogs/sssm/svnimg.log
done


#监控文件
inotifywait -mrq --timefmt '%d/%m/%y/%H:%M' --format '%T %w %f' -e modify,delete,create,attrib /root/test/1.txt | while read file
do
  echo xiugai $(date) >> /root/test/2.txt
done
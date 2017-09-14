 #!/usr/bin/env bash
 #file.txt为文件清单，将需要打包的class文件一行一个列在清单内。
#FILES=$(cat file.txt |awk '{print $1}')
#F=`cat file.txt |wc -l`
DIR=hotbin
if test -e ${DIR}
then
  echo -e "\033[32;1m ${DIR}exist,delete and remake \033[0m"
  rm -rf ${DIR}
  mkdir -p ${DIR}
else
  echo -e "\033[32;1m ${DIR} not exist,a new one made \033[0m"
  mkdir -p ${DIR}
fi
#for i in `seq 1 ${F}`
#do
#  file=`cat file.txt|sed -n ${i}p`
#if  [ ${file} ]
#  then
#  cp -r ${file} ${DIR}
#  echo -e "\033[32;1m add the file ${file} to ${DIR} \033[0m"
#  fi
#done
cat file.txt | while read i
do
   cp -r $i ${DIR}
   echo -e "\033[32;1m add the file ${file} to ${DIR} \033[0m"
done
zip -q -r ${DIR}.zip ${DIR}
echo -en "\033[31;1m compress file ${DIR}.zip complete \033[0m"
echo

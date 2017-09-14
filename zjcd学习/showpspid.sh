PSNAME=$1
if [ ! $1 ]; then
    echo 'usage: ./sh.sh psname'
    exit;
fi
ps -ef |grep whp|grep ${PSNAME} >1.txt
F=`cat 1.txt |wc -l`
for i in `seq 1 ${F}`
do
 con=`cat 1.txt|sed -n ${i}p`
 pid=`echo ${con}|awk '{print $2}'`
 a=`echo ${con}|awk '{print "进程号" " " $2 " " "服务名" $9}'`
 dir=`ls -l /proc/${pid}/cwd |awk '{print $11}'`
 echo $dir  $a
done

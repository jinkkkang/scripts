#城市的批量处理
city=(
xingtai
yangquan
fuxin
baicheng
jiamusi
)
for c in ${city[@]};
do	
    if [ -d /home/wwwroot/$c ];then
	cp -arf /home/wwwroot/yuxi/phpcms/templates/area/content/index.html  /home/wwwroot/$c/phpcms/templates/area/content/index.html
   	echo -e "\033[32;1m 【 /home/wwwroot/$c/  覆盖 】 \033[0m"
   else
   	 echo -e "\033[32;1m 【 /home/wwwroot/$c/  不存在】 \033[0m"

   fi
   
done
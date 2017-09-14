#!/usr/bin/bash

# 中华盛世线上表图片url的替换
# 需要替换内容的表
table=(
v9_boke
v9_bolan 
v9_caijing
v9_chuangye
v9_chuguo 
v9_daminggong
v9_dangan 
v9_dianzibao
v9_dili
v9_dimingxungen
v9_dushu 
v9_fangchan 
v9_fazhi 
v9_form_huiyuanxufei 
v9_form_juankuan
v9_form_zhaomubiao
v9_gangao
v9_gegupaihang 
v9_gongyi 
v9_gouwu 
v9_guoji 
v9_guonei
v9_guoneiyouqinglianjie 
v9_gushihangqing
v9_hits
v9_huanbao
v9_huaren
v9_hunlian
v9_ipbanned 
v9_jiadian
v9_jiaju 
v9_jiajushangcheng
v9_jiangkang
v9_jiaoyou
v9_jiaoyu
v9_jiating
v9_jigou 
v9_jinrong
v9_jubao 
v9_junshi
v9_kaifubiao
v9_keji
v9_keylink
v9_keyword
v9_lidaishengshi
v9_link
v9_linkage
v9_lishi 
v9_liushijingcai
v9_log
v9_luntan
v9_lvyou 
v9_meirong
v9_meishi
v9_member
v9_member_detail
v9_member_group
v9_member_homepage
v9_member_menu 
v9_member_verify
v9_member_vip
v9_mengxiangchengzhen
v9_menu
v9_message
v9_message_group
v9_mingxing 
v9_minqifengcai
v9_model 
v9_model_field 
v9_model_field1
v9_module
v9_mood
v9_mote
v9_nanren
v9_news
v9_nvren 
v9_page
v9_pay_account 
v9_pay_payment 
v9_pay_spend
v9_pingce
v9_pinglun
v9_position 
v9_qiandao
v9_qiche 
v9_qiye
v9_quanqiushichang
v9_queue 
v9_quwen 
v9_redian
v9_release_point
v9_rencaijiaoliu
v9_renwu 
v9_rongyudiantang 
v9_saishiyuzhi 
v9_search
v9_search_keyword 
v9_session
v9_shanghuzhanshi 
v9_shangjialm
v9_shaoer
v9_shehui
v9_shenghuobianli 
v9_shengshidaibiao
v9_shengshigongyi 
v9_shengshiguangbo
v9_shengshihuanbao
v9_shengshihuiyuan
v9_shengshishenghuo
v9_shengshiyingxiang 
v9_shequ 
v9_sheying
v9_shipin
v9_shishang 
v9_shoucang 
v9_shuhua
v9_shuma 
v9_shumatehui
v9_special
v9_special_content
v9_taihai
v9_template_bak
v9_tianxiashiye
v9_tiyu
v9_tougao
v9_tupian
v9_wenhua
v9_wenhuaqiangguo 
v9_wenxue
v9_xiaofei
v9_xiaoyuan 
v9_xiju
v9_xuexi 
v9_yijianfankui
v9_yingshi
v9_yinyue
v9_yishu 
v9_yishuqinghuai
v9_youxi 
v9_youxuantuijian 
v9_yule
v9_zhaoshang
v9_zhengjuan
v9_zhibobaodao 
v9_zhimingshejishi
v9_zhinengjiating 
v9_zhuangxiu
v9_zhuangxiushili 
v9_zhuanti
v9_ziran 
v9_zongyi
v9_ztfc
)

# 数据库地址
dbhost=rm-2ze20t42309383sek.mysql.rds.aliyuncs.com
#数据库用户
dbuser=zhss
#数据库密码
dbpd=de8GvDza
#存储恢复数据的数据库名称
#最好新建一个库用来专门存储恢复的数据
# create database  yy default character set utf8; 
dbname=phpcmsv9


#判断命令是否执行成功
reback(){
if [ $? = 0 ]; then
    echo -e "\033[32;1m 【 执行成功 】 \033[0m"
else
    echo -e "\033[31;1m 【 执行失败 】 \033[0m"
fi
}



for c in ${table[@]};
do	

    mysql -h$dbhost -u$dbuser -p$dbpd -e "use $dbname ; update $c set thumb=replace(thumb,'59.110.21.36','img.zhonghuass.cn');"
    echo -e "\033[36;1m 【 替换表 v9_${c} 】 \033[0m"
    reback
done




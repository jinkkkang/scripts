#!/usr/bin/bash
# -*- coding: utf-8 -*-

#这是一个监控服务器服务运行的脚本
import os
import time
import smtplib
import string
import smtplib
import logging
from email.mime.text import MIMEText
from email.header import Header
from subprocess import Popen


#日志格式配置
logging.basicConfig(level=logging.DEBUG,
                format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                datefmt='%a, %d %b %Y %H:%M:%S',
                filename='/var/log/monitor.log',
                filemode='a')


# 第三方 SMTP 服务,用作报警邮件
mail_host = "mail.zhonghuass.cn"  # 设置服务器
mail_user = "jinkangkang"  # 用户名
mail_pass = "7085630jinkang"  # 口令

sender = 'jinkangkang@zhonghuass.cn'
receivers = ['1547182170@qq.com']  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱

def  sendmail(server,error):
	try:
		message = MIMEText(error, 'plain', 'utf-8')
		message['From'] = Header("服务器异常报警", 'utf-8')
		message['Subject'] = Header(server, 'utf-8')
		smtpObj = smtplib.SMTP()
		smtpObj.connect(mail_host, 25)
		smtpObj.login(mail_user, mail_pass)
		smtpObj.sendmail(sender, receivers, message.as_string())
	except smtplib.SMTPException:
		logging.debug("sendmail failed")


server_pro = "邮件服务器"
server_start={
    'nginx': 'service nginx start',
    'mysql': 'service mysqld start',
    'php': 'service php-fpm start'
}
srever_pid={
    'nginx': '/usr/local/nginx/logs/nginx.pid',
    'mysql': '/var/run/mysqld/mysqld.pid',
    'php': '/usr/local/php/var/run/php-fpm.pid'
}

while True:
	time.sleep(5)
	for pro in  srever_pid:
		if not os.path.exists(srever_pid[pro]):
			err = server_pro + "  " + pro + "  is not runing,please check it as soon as possible"
			logging.debug(err)
			sendmail(server_pro,err)
			proc = Popen(server_start[pro], shell=True)
  





	
#!/usr/bin/env bash
# ver node 7.5.0
INSTALL_DIR=/usr/local
mkdir -p ${INSTALL_DIR}
cd ${INSTALL_DIR}
echo -en "\033[34;1mCheck File node-v7.5.0-linux-x64.tar.gz ... \033[0m"
MD=$(md5sum node-v7.5.0-linux-x64.tar.gz | awk '{print $1}')
if
  (test "$MD" == "4e69ff78166f62e36a0226d93e33193a") > /dev/null
then
  echo -e "\033[35;1m The file exists!!!【SKIP】 \033[0m"
else
  rm -rf node-v7.5.0-linux-x64.tar.gz
  wget -c -q http://zabbix.8090mt.com/node-v7.5.0-linux-x64.tar.gz
  if [ $? != 0 ]; then
    echo -e "\033[31;1m【FAIL】\033[0m"
    exit 1
  else
    echo -e "\033[32;1m【 OK 】\033[0m"
  fi
fi
tar zxf node-v7.5.0-linux-x64.tar.gz
cd /usr/bin
ln -s ${INSTALL_DIR}/node-v7.5.0-linux-x64/bin/node ./
ln -s ${INSTALL_DIR}/node-v7.5.0-linux-x64/bin/npm ./
echo -en '\033[34;1mAdd cnpm mode   \033[0m'
if
	 cat ~/.bashrc | grep 'cnpm' > /dev/null
then
	echo -e "\033[35;1m【SKIP】\033[0m"
else
	echo '' >> /etc/rc.local
  echo 'alias cnpm="npm --registry=https://registry.npm.taobao.org --cache=$HOME/.npm/.cache/cnpm --disturl=https://npm.taobao.org/dist --userconfig=$HOME/.cnpmrc"' >> ~/.bashrc
  alias cnpm="npm --registry=https://registry.npm.taobao.org --cache=$HOME/.npm/.cache/cnpm --disturl=https://npm.taobao.org/dist --userconfig=$HOME/.cnpmrc"
	if [ $? -eq 0 ]; then
		echo -e "\033[32;1m【 OK 】\033[0m"
	else
		echo -e "\033[31;1m【 FAIL 】 \033[0m"
	fi
fi
npm install supervisor -g
npm install forever -g

#!/bin/sh
DBIP=$1
DBUSER=$2
DBPASS=$3
DBNAME=$4


if [ ! $4 ]; then
    echo 'usage: ./dumpdb dbip dbuser dbpass dbname'
    exit;
fi

if [ ! $1 ]; then
    echo 'usage: ./sh.sh psname'
    exit;
fi

/usr/bin/mysqldump -h$DBIP -u$DBUSER -p$DBPASS -a -q --add-drop-table --default-character-set=utf8 --hex-blob --single-transaction -B $DBNAME > ${DBNAME}.sql
zip -r2 ${DBNAME}.zip ./${DBNAME}.sql
rm -rf ./${DBNAME}.sql

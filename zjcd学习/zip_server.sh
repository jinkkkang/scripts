#!/usr/bin/env bash
TIME=`date +%Y%m%d%H%M%S`
FILES=`ls |grep -v $0`
VERFILE=version.txt
echo ${TIME} >${VERFILE}
zip -q -r ngame_${TIME}.zip ${FILES}

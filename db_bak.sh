#!/usr/bin/bash
# clean log file 
user=root
passwd=s2s3s72m
database=sssm
dbdir=/data/sssm
mysqldump -u$user -p$passwd $database >  $dbdir/sssm_$(date +%Y%m%d_%H%M%S).sql

find $dbdir  -mtime +10 -type f -print  |xargs rm -rf

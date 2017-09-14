#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2016-02-16 11:39:21
# @Author  : Orz (NULL)
# @Link    : NULL
# @Version : $Id$

import os
import gzip
import tarfile
import zipfile
import sys


# tar解压
def un_tar(file_name):
    tar = tarfile.open(file_name)
    names = tar.getnames()
    for name in names:
        print "正在解压 : %s" % (name)
        tar.extract(name)
        if os.path.splitext(name)[1] == ".tgz" or os.path.splitext(name)[1] == ".zip" or os.path.splitext(name)[1] == ".gz" or os.path.splitext(name)[1] == ".tar":
            extract.append(name)
    # extract.remove(file_name)
    tar.close()

# gzip解压
def un_gz(file_name):
    if os.path.splitext(file_name)[1] == '.tgz':
        f_name = file_name.replace(".tgz", "")
    elif os.path.splitext(file_name)[1] == '.gz':
        f_name = file_name.replace(".gz", "")
    '''分割'''
    print "获取文件 : %s" % (file_name)
    g_file = gzip.GzipFile(file_name)
    open(f_name, "w+").write(g_file.read())
    g_file.close()
    un_tar(f_name)
    os.system("rm -rf %s" % (f_name))
    extract.remove(file_name)

# zip解压
def un_zip(file_name):
    zip_file = zipfile.ZipFile(file_name, 'r')
    print "获取文件 : %s" % (file_name)
    for name in zip_file.namelist():
        print "正在解压 : %s" % (name)
        data = zip_file.read(name)
        file = open(name, 'w+b')
        file.write(data)
        file.close()
        if os.path.splitext(name)[1] == ".tgz" or os.path.splitext(name)[1] == ".zip" or os.path.splitext(name)[1] == ".gz" or os.path.splitext(name)[1] == ".tar":
            extract.append(name)
    '''分割'''
    extract.remove(file_name)
    zip_file.close()


if __name__ == '__main__':
    # 创建解压数组
    extract = []
    ex_file = os.listdir(os.getcwd())
    for x in ex_file:
        if os.path.splitext(x)[1] == ".tgz" or os.path.splitext(x)[1] == ".zip" or os.path.splitext(x)[1] == ".gz" or os.path.splitext(x)[1] == ".tar":
            extract.append(x)
    # print extract
    '''分割'''
    while extract:
        for xxx in extract:
            zzz = os.path.splitext(xxx)
            if zzz[1] == '.zip':
                un_zip(xxx)
            elif zzz[1] == '.tgz' or zzz[1] == '.gz':
                un_gz(xxx)
    '''分割'''
    print "解压完成"

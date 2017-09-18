# -*- coding: utf-8 -*-
import psutil
import os
import sys
plat = {
	"linux2": "Linux系统",
	"win32": "Windows系统"
}

def Red(s):
    return "%s[31;2m%s%s[0m"%(chr(27), s, chr(27))

print Red("操作系统"),plat[sys.platform]
print psutil.disk_usage('/')
print Red("CPU逻辑个数"),psutil.cpu_count()
print Red("CPU物理个数"),psutil.cpu_count(logical=False)

mem = psutil.virtual_memory()
mem_total = mem.total/1048576
mem_free = mem.free/1048576
per_free = round((mem_free/mem_total)*100,2)
print Red("总内存"),mem_total,"M",Red("空闲内存"),mem_free,"M",Red("空闲比"),per_free,"%"

mem = {}
for i in psutil.pids():
	p = psutil.Process(i)
	mem [i] = p.memory_percent()

res =  sorted(mem.items(),key=lambda item:item[1],reverse=True)[0:10]

for i in  res:
	p = psutil.Process(i[0])
	print "***********************"
	print Red("进程名称"),p.name()
	print Red("进程路径"),p.exe()
	print Red("进程状态"),p.status()
	print Red("内存占比"),round(p.memory_percent(),2),"%"
	print "***********************"







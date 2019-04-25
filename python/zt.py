# -*- coding:utf8 -*-  

import sys
import os
import re
import time

def getDateStr():
    dateStr = time.strftime("%Y%m%d", time.localtime()) 
    return dateStr

def getLastLine(fullpath):
    fr = open(fullpath,'r',encoding='utf8')
    targetLine = ""
    while 1:
        mLine = fr.readline()
        if not mLine:
            break
        targetLine = mLine
    return targetLine   

def parseZhangTing(date,fullpath,outfullpath):
    print(fullpath)
    fr = open(fullpath,'r',encoding='utf8')
    line = fr.readline()             # 调用文件的 readline()方法
    stocks = []
    while line:
        #print(line)                 # 后面跟 ',' 将忽略换行符
        # print(line, end = '')　　　# 在 Python 3中使用
        line = fr.readline()
        matchObj = re.search("(\w+)\s{4}(\d+)\s{4}(\d+)\s{4}(\w+)\s{4}(.*)\n", line, re.I)
        if matchObj:
            #print(matchObj.group())
            name = matchObj.group(1)
            ztno = matchObj.group(2)
            kbno = matchObj.group(3)
            keywords = matchObj.group(4)
            description = matchObj.group(5)
            stock = "%s===%s===%s===%s===%s" % (date,name,ztno,keywords,description)
            stocks.append(stock)
            print(stock)

    fr.close()
    #print(stocks)

    # 写入文件
    outstr = "\n".join(stocks)
    fw = open(outfullpath,'a+',encoding='utf-8')
    fw.write(outstr)
    fw.close()


def commitToGit():
    #切换工作目录
    os.chdir("/Users/andy/Github/StockHelper/document/")
    cmd = "git add zhangting.dat"
    os.system(cmd)
    cmd = 'git commit -m "zhangting"'
    os.system(cmd)
    cmd = 'git push'
    os.system(cmd)

def processZhangTing():
    dateStr = getDateStr()
    fullpath = "/Users/andy/Github/StockHelper/python/zhangting/%s.txt" % dateStr
    outfullpath = "/Users/andy/Github/StockHelper/document/zhangting.dat"
    lastline = getLastLine(outfullpath)
    if dateStr in lastline:
        print("already found")
    else:
        print("not found")
        parseZhangTing(dateStr,fullpath,outfullpath)
        commitToGit()
    

if __name__ == '__main__':
    processZhangTing()
else:
    processZhangTing()
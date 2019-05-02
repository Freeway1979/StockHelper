# -*- coding:utf8 -*-  

import sys
import os
import re
import time

def getDateStr():
    dateStr = time.strftime("%Y%m%d", time.localtime()) 
    return dateStr

def checkDateInFile(fullpath,keyword):
    fr = open(fullpath,'r',encoding='utf8')
    targetLine = ""
    while 1:
        mLine = fr.readline()
        if not mLine:
            break
        if keyword in mLine:
            targetLine = mLine
            break
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
        text = "%s    %s" % (date,line)
        oo = text.split('    ')
        if len(oo) > 3:
            stock = "===".join(oo)
            stock = stock.replace('\n','')
            stocks.append(stock)
            print(stock)

    fr.close()
    #print(stocks)

    # 写入文件
    print('writing...')
    outstr = "\n".join(stocks)
    fw = open(outfullpath,'a+',encoding='utf-8')
    fw.write(outstr)
    fw.close()
    print('written.')


def commitToGit():
    print('committing to git')
    #切换工作目录
    os.chdir("/Users/andy/Github/StockHelper/document/")
    cmd = "git add zhangting.dat"
    os.system(cmd)
    cmd = 'git commit -m "zhangting"'
    os.system(cmd)
    cmd = 'git push'
    os.system(cmd)
    print('committed.')

def processZhangTing(dd):
    dateStr = getDateStr()
    if dd:
        dateStr = dd
    fullpath = "/Users/andy/Github/StockHelper/python/zhangting/%s.txt" % dateStr
    outfullpath = "/Users/andy/Github/StockHelper/document/zhangting.dat"
    lastline = checkDateInFile(outfullpath,dateStr)
    if dateStr in lastline:
        print("already found")
    else:
        print("not found")
        parseZhangTing(dateStr,fullpath,outfullpath)
        commitToGit()
    

if __name__ == '__main__':
    dd = '20190425'
    if len(sys.argv)>1:
        dd = sys.argv[1]
    if dd:
        processZhangTing(dd)
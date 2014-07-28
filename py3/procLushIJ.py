# -*- coding: utf-8 -*-
"""
Created on Thu Jul 24 09:51:02 2014

@author: J. R. Minter
"""

import sys, traceback, subprocess, os

homDir = os.environ['HOME']
relDir = "/work/snippets/py3"
wd = homDir + relDir
os.chdir(wd)

# ijDir = "C:/Apps/ImageJ"
# java = ijDir + "/jre/bin/java.exe"
ijDir = "C:/Apps/Fiji.app"
java = ijDir + "/java/win64/jdk1.6.0_24/jre/bin/java.exe"

ijmPath = ijDir + "/macros/anaLushington.ijm"
imgPath = "C:/Data/images/QM13-03-01F-Lushington/qm-03966-KJL-031/qm-03966-KJL-031-01.dm3"

# cmd =  java + " -cp " + ijDir + "/ij.jar ij.ImageJ -b '" + ijmPath + "' '" + imgPath + "'"

cmd =  java + " -cp " + ijDir + "/jars/imagej-2.0.0-rc-9.jar ij.ImageJ -b " + imgPath + " " + ijmPath

print(cmd)
p = subprocess.Popen(cmd, shell=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
out = p.stdout.read().strip()
print(out)
#!/bin/python
import os, glob

root_path = os.getcwd() + '/rtl/**/*.sv'

filelist = []
for file in glob.glob(root_path, recursive=True):
    filelist.append(file)

with open('./filelist.f', 'w', encoding='utf-8') as fp:
    for f in filelist:
        fp.write('../' + os.path.relpath(f) + '\n')
        # print(os.path.relpath(f))

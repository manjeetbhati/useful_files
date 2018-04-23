import os

file_list = []

def trim_lines(files):
    with open(files, "rb") as fi:
        content = fi.readlines()
        a=0
        for line in content:
            if a==53:
                import pdb;pdb.set_trace()
            file_list.append(line.split(":")[1])
            a = a+1
        return file_list
   
import pdb;pdb.set_trace()
bc = trim_lines("testb")
print bc



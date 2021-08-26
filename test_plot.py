#!/usr/bin/env python
# encoding: utf-8


#import matplotlib
#matplotlib.use('Agg')
import matplotlib.pyplot as plt
cpu_mv_file = 'sum.log'
X1,Y1 = [],[]

for i in range(1,7):
    X1.append(500*i)
with open(cpu_mv_file, 'r')as f1:
    lines=f1.readlines()
    for line in lines:
        y1_arr = line.split(" ")
        Y1.append(float(y1_arr[0].strip()))


#print(X)
#print(Y)
plt.xlabel('x/kb')
#y轴文本
plt.ylabel('latency/ns')
#cpu memcpy
plt.plot(X1,Y1,color = "r")
#DSA move
plt.show()


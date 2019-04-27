# loss rate in different input rate (mpps)
import random
import math
import sys

fifo = [0,0,0,0]
fifoa =[]
fifob =[]
fifoc =[]
fifod =[]
inrate = 0
testli = [0.15,0.3,0.45,0.6]
testli2 = [0.3]
latency0 = 2+6+5+22+7
tmp = 0
for j in range(500):
	tmp = tmp + 1.0/500
	fifob.append(tmp)

for i in testli2:
	fifo = [0,0,0,0]
	fifoa =[]
	fifoc =[]
	fifod =[]
	inrate = i
	for pkt in range(5000):
		out1 = int(random.random()*4)
		out2 = int(random.random()*4)
		out3 = int(random.random()*4)
		out4 = int(random.random()*4)

		# inrate = 0.6
		if random.random() < inrate:
			fifo[out1] = fifo[out1] + 1
		if random.random() < inrate:
			fifo[out2] = fifo[out2] + 1
		if random.random() < inrate:
			fifo[out3] = fifo[out3] + 1
		if random.random() < inrate:
			fifo[out4] = fifo[out4] + 1

		outrate = 0.67
		if random.random() < outrate:
			if fifo[0] > 0:
				fifo[0] = fifo[0] - 1
		if random.random() < outrate:
			if fifo[1] > 0:
				fifo[1] = fifo[1] - 1
		if random.random() < outrate:
			if fifo[2] > 0:
				fifo[2] = fifo[2] - 1
		if random.random() < outrate:
			if fifo[3] > 0:
				fifo[3] = fifo[3] - 1
		
		for j in range(4):
			fifoa.append(fifo[j] + latency0)
	fifoa.sort()
	# print fifoa
	for j in range(500):
		fifoc.append(fifoa[40*j])
	for j in range(500):
		print fifoc[j],"\t",fifob[j]*100


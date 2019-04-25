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

for i in range(20):
	inrate = inrate + 0.03
	fifo = [0,0,0,0]
	fifoa =[]
	for test in range(20):
		for pkt in range(50000):
			out1 = int(random.random()*4)
			out2 = int(random.random()*4)
			out3 = int(random.random()*4)
			out4 = int(random.random()*4)

			
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
			fifoa.append(fifo[0])
			fifoa.append(fifo[1])
			fifoa.append(fifo[2])
			fifoa.append(fifo[3])

	fifoa.sort()
	loss = 0
	for i in fifoa:
		if i <12 :
			continue
		else:
			loss = loss + 1
	# print "input rate =",inrate*400,"loss rate", loss*1.0/len(fifoa)
	print inrate*200,"\t", loss*1.0/len(fifoa)*100

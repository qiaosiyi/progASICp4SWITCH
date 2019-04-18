import random
import math
import sys

cache = 0
cachetime = 1
out = 7
inp = 0
fifo = 0


for i in range(10000):
	v = int(64+random.random()*1452)
	# print "v",v
	# print "cache",cache
	if cache + v <= 8000:
		cachetime = cachetime + 1
		cache = cache + v
	else:
		# print "",cachetime
		
		if inp + cachetime <= out:
			fifo = fifo + 1
			inp = inp + cachetime
		else:
			out = out + 7
			# print "fifo",fifo
			fifo = 0
		cache = v
		cachetime = 1
i = 0
cache = 0
cachetime = 1
f = open('a.txt','r')
for line in open('a.txt'):
	i = i + 1
	v = int(line)
	# print "i",i,
	if cache + v <= 8000:
		cachetime = cachetime + 1
		cache = cache + v
		# print "v",v
	else:
		# print "cachetime",cachetime
		if inp + cachetime <= out:
			fifo = fifo + 1
			inp = inp + cachetime
		else:
			out = out + 7
			print "fifo",fifo
			fifo = 0
		cache = v
		cachetime = 1
f.close() 



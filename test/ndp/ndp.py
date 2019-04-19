import random
import math
import sys

p = [0,0.3725,0.536875,0.70875,0.825625,0.911875,0.9525,0.975625,0.99,0.9975,1]
p2 = [0,0.407,0.546,0.636,0.7085,0.7595,0.7955,0.82,0.846,0.8805,0.906,0.9245,0.9385,0.952,0.969,0.9785,0.9885,0.9955,0.997,0.998,0.9985,0.9995,1]
f = 12*1024
result_random = []
result_real = []

def get_delay_random():
	v = random.random()
	j = 0
	for i in p:
		if v >= p[j] and v<=p[j+1]:
			break
		j = j + 1
	return j
def get_delay_real():
	v = random.random()
	j = 0
	for i in p2:
		if v >= p2[j] and v<=p2[j+1]:
			break
		j = j + 1
	return j

def prcss(result):
	summ = 0
	for i in range(len(result)):
		summ = summ +result[i]
	avr = summ / len(result)
	maxx = max(result)
	# print "avr",avr,"max",maxx
	return avr,maxx

def prcss_real(result):
	summ = 0
	for i in range(len(result)):
		summ = summ + result[i]

	avr = summ / len(result)/12.0/1024*100
	maxx = max(result)/12.0/1024*100
	# print "avr",avr,"maxx",maxx
	return avr,maxx

# #####################ramdom test
# avr = 0
# maxx = 0
# for test in range(20):
# 	for i in range(500):
# 		v = get_delay_random()
# 		leng = 0
# 		for j in range(v):
# 			if random.random()<1:
# 				tmp = int(64+random.random()*1452)
# 			else:
# 				tmp = 0
# 			leng = leng + tmp
# 		result_random.append(leng*1.0 / f)
# 	tavr,tmaxx = prcss(result_random)
# 	avr = avr + tavr
# 	maxx = maxx + tmaxx
# 	result_random = []
# print "avr =",avr/20.0,"maxx =",maxx/20.0
################################



#####################real test
avr = 0
maxx = 0
f = open('a.txt','r')
for test in range(20):
	for i in range(500):
		v = get_delay_real()
		leng = 0

		for j in range(v):
			if random.random()<1:
				tmp = int(f.readline())
			else:
				tmp = 0
			leng = leng + tmp
		# print leng
		result_real.append(leng)
	tavr,tmaxx = prcss_real(result_real)
	avr = avr + tavr
	maxx = maxx + tmaxx
	result_real = []
print "avr =",avr/20.0,"maxx =",maxx/20.0
f.close() 

a=0
for i in range(500):
	a = a + 1/500.0
	# print a

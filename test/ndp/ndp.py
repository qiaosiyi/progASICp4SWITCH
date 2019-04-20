import random
import math
import sys

p = [0,0.3725,0.536875,0.70875,0.825625,0.911875,0.9525,0.975625,0.99,0.9975,1]
p2 = [0,0.407,0.546,0.636,0.7085,0.7595,0.7955,0.82,0.846,0.8805,0.906,0.9245,0.9385,0.952,0.969,0.9785,0.9885,0.9955,0.997,0.998,0.9985,0.9995,1]
f = 12*1024
result_random = []
result_real = []
ftest = [0.02,0.05,0.2,0.5,1]

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
	result.sort()
	maxx95 = result[int(len(result)*0.95)]
	# print "avr",avr,"max",maxx
	return avr,maxx,maxx95

def prcss_real(result):
	summ = 0
	for i in range(len(result)):
		summ = summ + result[i]

	avr = summ / len(result)/12.0/1024*100
	maxx = max(result)/12.0/1024*100
	result.sort()
	maxx95 = result[int(len(result)*0.95)]/12.0/1024*100
	# print "avr",avr,"maxx",maxx
	return avr,maxx,maxx95

#####################ramdom test

# for futest in ftest:
# 	avr = 0
# 	maxx = 0
# 	maxx95 = 0
# 	for test in range(20):
# 		for i in range(500):
# 			v = get_delay_random()
# 			leng = 0
# 			for j in range(v):
# 				if random.random()<futest:
# 					tmp = int(64+random.random()*1452)
# 				else:
# 					tmp = 0
# 				leng = leng + tmp
# 			result_random.append(leng*1.0 / f)
# 		tavr,tmaxx,tmaxx95 = prcss(result_random)
# 		avr = avr + tavr
# 		maxx = maxx + tmaxx
# 		maxx95 = maxx95 + tmaxx95
# 		result_random = []
# 	# print "avr =",avr/20.0*100,"maxx =",maxx/20.0*100,"maxx95 =",maxx95/20.0*100
# 	print avr/20.0*100,maxx95/20.0*100
###############################



# #####################real test

f = open('a.txt','r')
for futest in ftest:
	avr = 0
	maxx = 0
	maxx95 = 0
	for test in range(20):
		for i in range(500):
			v = get_delay_real()
			leng = 0

			for j in range(v):
				if random.random()<futest:
					tmp = int(f.readline())
				else:
					tmp = 0
				leng = leng + tmp
			result_real.append(leng)
		tavr,tmaxx,tmaxx95 = prcss_real(result_real)
		avr = avr + tavr
		maxx = maxx + tmaxx
		maxx95 = maxx95 + tmaxx95
		result_real = []
	# print "avr =",avr/20.0,"maxx =",maxx/20.0,"maxx95 =",maxx95/20.0
	print avr/20.0,maxx95/20.0
f.close() 

a=0
for i in range(500):
	a = a + 1/500.0
	# print a

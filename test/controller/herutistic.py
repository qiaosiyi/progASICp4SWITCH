# simulated annealing for table allocation
import random
import math
import sys
import copy
# num_pipeline = 8
num_id = 256
load = [988 , 988 , 984 , 983 , 982 , 981 , 975 , 973 , 970 , 968 , 966 , 962 , 948 , 946 , 944 , 936 , 933 , 931 , 926 , 918 , 917 , 914 , 912 , 908 , 908 , 908 , 906 , 899 , 897 , 895 , 893 , 884 , 883 , 875 , 872 , 869 , 867 , 864 , 858 , 850 , 850 , 841 , 839 , 831 , 829 , 816 , 812 , 811 , 798 , 798 , 791 , 784 , 784 , 778 , 776 , 775 , 770 , 764 , 762 , 757 , 757 , 750 , 745 , 743 , 737 , 734 , 733 , 730 , 723 , 720 , 710 , 709 , 708 , 706 , 703 , 703 , 700 , 698 , 695 , 677 , 676 , 672 , 672 , 672 , 671 , 663 , 661 , 661 , 655 , 649 , 641 , 641 , 640 , 639 , 637 , 629 , 624 , 623 , 620 , 620 , 616 , 616 , 615 , 613 , 605 , 603 , 600 , 596 , 595 , 584 , 574 , 572 , 566 , 565 , 564 , 560 , 559 , 551 , 539 , 538 , 535 , 534 , 531 , 530 , 525 , 517 , 517 , 515 , 514 , 512 , 507 , 503 , 496 , 496 , 493 , 488 , 487 , 484 , 482 , 480 , 477 , 476 , 467 , 460 , 455 , 453 , 452 , 451 , 446 , 427 , 426 , 420 , 415 , 414 , 403 , 401 , 399 , 398 , 391 , 388 , 384 , 376 , 374 , 368 , 360 , 358 , 340 , 336 , 326 , 325 , 318 , 316 , 310 , 308 , 306 , 299 , 297 , 294 , 287 , 283 , 282 , 278 , 262 , 261 , 255 , 254 , 254 , 253 , 247 , 247 , 244 , 242 , 242 , 237 , 237 , 236 , 234 , 230 , 229 , 224 , 216 , 215 , 214 , 213 , 210 , 209 , 209 , 202 , 202 , 199 , 195 , 178 , 170 , 165 , 165 , 161 , 160 , 155 , 148 , 142 , 140 , 139 , 139 , 130 , 129 , 128 , 127 , 125 , 119 , 108 , 103 , 98 , 91 , 89 , 81 , 72 , 67 , 65 , 62 , 58 , 57 , 57 , 55 , 54 , 54 , 54 , 37 , 36 , 33 , 30 , 30 , 19 , 16 , 15 , 5 , 4]
load_random = [624 , 398 , 244 , 391 , 254 , 503 , 142 , 496 , 872 , 37 , 242 , 427 , 299 , 308 , 776 , 775 , 663 , 103 , 119 , 282 , 966 , 452 , 460 , 968 , 936 , 661 , 89 , 784 , 620 , 850 , 374 , 613 , 414 , 91 , 551 , 743 , 677 , 403 , 202 , 401 , 376 , 637 , 710 , 931 , 360 , 30 , 596 , 698 , 841 , 487 , 253 , 603 , 906 , 584 , 559 , 65 , 700 , 326 , 4 , 829 , 982 , 426 , 864 , 671 , 278 , 15 , 262 , 477 , 566 , 36 , 127 , 5 , 214 , 139 , 655 , 641 , 165 , 672 , 858 , 737 , 988 , 237 , 139 , 229 , 944 , 215 , 108 , 55 , 155 , 812 , 706 , 230 , 125 , 869 , 384 , 723 , 199 , 908 , 672 , 988 , 62 , 538 , 484 , 316 , 946 , 811 , 981 , 703 , 209 , 708 , 616 , 482 , 476 , 340 , 539 , 948 , 58 , 926 , 970 , 531 , 455 , 210 , 33 , 750 , 757 , 565 , 661 , 336 , 242 , 897 , 798 , 247 , 310 , 129 , 839 , 16 , 306 , 641 , 178 , 297 , 202 , 816 , 560 , 730 , 224 , 620 , 515 , 54 , 672 , 895 , 254 , 534 , 467 , 488 , 294 , 867 , 496 , 30 , 770 , 446 , 213 , 629 , 54 , 733 , 983 , 908 , 893 , 899 , 649 , 605 , 875 , 453 , 287 , 703 , 791 , 600 , 884 , 358 , 480 , 81 , 784 , 912 , 318 , 798 , 54 , 148 , 984 , 525 , 962 , 140 , 130 , 595 , 517 , 160 , 237 , 762 , 574 , 216 , 67 , 709 , 572 , 19 , 918 , 255 , 261 , 57 , 98 , 170 , 975 , 615 , 695 , 623 , 734 , 720 , 640 , 195 , 165 , 883 , 512 , 517 , 72 , 933 , 745 , 917 , 399 , 639 , 764 , 676 , 908 , 973 , 236 , 530 , 388 , 831 , 757 , 209 , 535 , 914 , 128 , 493 , 778 , 247 , 283 , 850 , 420 , 514 , 325 , 57 , 564 , 616 , 234 , 507 , 368 , 415 , 161 , 451]
realload = [624 , 398 , 244 , 391 , 254 , 503 , 142 , 496 , 872 , 37 , 242 , 427 , 299 , 308 , 776 , 775 , 663 , 103 , 119 , 282 , 966 , 452 , 460 , 968 , 936 , 661 , 89 , 784 , 620 , 850 , 374 , 613 , 414 , 91 , 551 , 743 , 677 , 403 , 202 , 401 , 376 , 637 , 710 , 931 , 360 , 30 , 596 , 698 , 841 , 487 , 253 , 603 , 906 , 584 , 559 , 65 , 700 , 326 , 4 , 829 , 982 , 426 , 864 , 671 , 278 , 15 , 262 , 477 , 566 , 36 , 127 , 5 , 214 , 139 , 655 , 641 , 165 , 672 , 858 , 737 , 988 , 237 , 139 , 229 , 944 , 215 , 108 , 55 , 155 , 812 , 706 , 230 , 125 , 869 , 384 , 723 , 199 , 908 , 672 , 988 , 62 , 538 , 484 , 316 , 946 , 811 , 981 , 703 , 209 , 708 , 616 , 482 , 476 , 340 , 539 , 948 , 58 , 926 , 970 , 531 , 455 , 210 , 33 , 750 , 757 , 565 , 661 , 336 , 242 , 897 , 798 , 247 , 310 , 129 , 839 , 16 , 306 , 641 , 178 , 297 , 202 , 816 , 560 , 730 , 224 , 620 , 515 , 54 , 672 , 895 , 254 , 534 , 467 , 488 , 294 , 867 , 496 , 30 , 770 , 446 , 213 , 629 , 54 , 733 , 983 , 908 , 893 , 899 , 649 , 605 , 875 , 453 , 287 , 703 , 791 , 600 , 884 , 358 , 480 , 81 , 784 , 912 , 318 , 798 , 54 , 148 , 984 , 525 , 962 , 140 , 130 , 595 , 517 , 160 , 237 , 762 , 574 , 216 , 67 , 709 , 572 , 19 , 918 , 255 , 261 , 57 , 98 , 170 , 975 , 615 , 695 , 623 , 734 , 720 , 640 , 195 , 165 , 883 , 512 , 517 , 72 , 933 , 745 , 917 , 399 , 639 , 764 , 676 , 908 , 973 , 236 , 530 , 388 , 831 , 757 , 209 , 535 , 914 , 128 , 493 , 778 , 247 , 283 , 850 , 420 , 514 , 325 , 57 , 564 , 616 , 234 , 507 , 368 , 415 , 161 , 451]
# 


def gen_random_load():
	load = []
	for i in range(num_id):
		a = int(random.random() * 1000)
		load.append(a)
	for j in load:
		print j,",",
	print "-------------"
	load.sort(reverse=True)
	for j in load:
		print j,",",

# gen_random_load256()
def J(Y0):
	l = len(Y0)
	a = []
	suma = []
	for i in range(l):
		a.append(Y0[i])
		suma.append(sum(a[i]))
	# print "J()",a,b,c,d
	avg = (sum(suma))/l
	err = 0
	for i in range(l):
		err = err + (avg - suma[i])*(avg - suma[i])
	err = err
	# err = (avg - a)*(avg - a) + (avg - b)*(avg - b) + (avg - c)*(avg - c) + (avg - d)*(avg - d)
	# print "==",a,b,c,d
	# print err
	return err

def init():
	a = [0]
	b = [0]
	c = [0]
	d = [0]
	for i in load:
		suma = sum(a)
		sumb = sum(b)
		sumc = sum(c)
		sumd = sum(d)
		if suma <= sumb and suma <=sumc and suma <=sumd:
			a.append(i)
		elif sumb <= suma and sumb <=sumc and sumb <=sumd:
			b.append(i)
		elif sumc <= suma and sumc <=sumb and sumc <=sumd:
			c.append(i)
		else:
			d.append(i)
	print a
	print b
	print c
	print d
	# J(a,b,c,d)
	return a,b,c,d

def init_without_opt(num_pipeline):
	a = []

	each = num_id / num_pipeline#64

	for i in range(num_pipeline):
		a.append(load[each*i:each*i+each])
	return a

def switch(a,ai,b,bi):
	tmp = a[ai]
	a[ai] = b[bi]
	b[bi] = tmp
	return a,b
		
def get_2_groupID(num_pipeline):
	each = num_id / num_pipeline#64
	a = int(random.random()*num_pipeline)
	b = int(random.random()*num_pipeline)
	while a == b:
		b = int(random.random()*num_pipeline)
	ai = int(random.random()*each)
	bi = int(random.random()*each)
	return a,ai,b,bi

def run(num_pipeline,errbar):
	Y = init_without_opt(num_pipeline)
	Yp1 = copy.deepcopy(Y) 
	jmin = 9999999999999
	times = 0
	err = 1

	average = sum(load_random)/num_pipeline
	while err > errbar:
		times = times + 1
		a,ai,b,bi = get_2_groupID(num_pipeline)
		# print "a,ai,b,bi",a,ai,b,bi
		l = num_pipeline
		switch(Yp1[a],ai,Yp1[b],bi)
		j0 = J(Y)
		j1 = J(Yp1)
		de = j0 - j1

		if de > 0 :
			Y = copy.deepcopy(Yp1)
			jmin = j1

			sum1 = []
			for i in range(l):
				sum1.append(sum(Yp1[i]))

			
			err = []
			# print sum1,average
			for i in range(l):
				err.append((sum1[i] - average)*1.0/average)

			err = max(err)
			# print "jmin =",jmin,"de",de, "times",times,"err",err*100,"%"
			pass
	# print times, err*100
	return times, err*100

result = []
for j in [4,5,6,7,8]:
	result.append([])
	# print "j =",j
	for i in range(120):
		times, err = run(j,0.03)
		tmp = str(times) + "," + str(err)
		# print "tmp",tmp
		result[j-4].append(tmp)
for j in range(len(result[0])):
	for k in range(len(result)):
		print result[k][j],",",
	print

result = []
for j in [4,5,6,7,8]:
	result.append([])
	# print "j =",j
	for i in range(120):
		times, err = run(j,0.05)
		tmp = str(times) + "," + str(err)
		# print "tmp",tmp
		result[j-4].append(tmp)
for j in range(len(result[0])):
	for k in range(len(result)):
		print result[k][j],",",
	print

result = []
for j in [4,5,6,7,8]:
	result.append([])
	# print "j =",j
	for i in range(120):
		times, err = run(j,0.07)
		tmp = str(times) + "," + str(err)
		# print "tmp",tmp
		result[j-4].append(tmp)
for j in range(len(result[0])):
	for k in range(len(result)):
		print result[k][j],",",
	print

result = []
for j in [4,5,6,7,8]:
	result.append([])
	# print "j =",j
	for i in range(120):
		times, err = run(j,0.09)
		tmp = str(times) + "," + str(err)
		# print "tmp",tmp
		result[j-4].append(tmp)
for j in range(len(result[0])):
	for k in range(len(result)):
		print result[k][j],",",
	print

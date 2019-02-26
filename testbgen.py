#read pcap text file
#generate verilog test init code
import re
file = open("3a.txt")
times = 0
def delfun(line):
	a = len(line)
	b = a/3
	out=''
	for i in range(b):
		out=out + line[3*i+1]
		out=out + line[3*i+2]
	return out
def reverse1(s):
	return s[::-1]
j = 0
tmp = ''
while 1:
	line = file.readline()
	if not line:
		print
		break
	if line[0] == "|":
		line = line[5:]
		line = delfun(line)
		l = len(line)/2
		# print line,"times=",times,"len",l
		times = times + 1
		if l <= 64:
			print "pkt_ctl[",j,"] = 4",";",
			tmp = "pkt_data["+str(j)+"] ='h"+reverse1(line)+";"
			print tmp,
			j = j+1
			continue
		if l <= 128:
			print "pkt_ctl[",j,"] = 1",";",
			tmp = "pkt_data["+str(j)+"] ='h"+reverse1(line[0:64*2])+";"
			print tmp,
			j = j+1
			print "pkt_ctl[",j,"] = 3",";",
			tmp = "pkt_data["+str(j)+"] ='h"+reverse1(line[64*2:])+";"
			print tmp,
			j = j+1
			continue
		if l >128:
			i = 1
			print "pkt_ctl[",j,"] = 1",";",
			tmp = "pkt_data["+str(j)+"] ='h"+reverse1(line[:64*2])+";"
			print tmp,
			j = j+1
			while (l*2 - i*64*2)>64*2 :
				print "pkt_ctl[",j,"] = 2",";",
				tmp = "pkt_data["+str(j)+"] ='h"+reverse1(line[64*2*i:64*2*i+64*2])+";"
				print tmp,
				j = j+1
				i = i + 1
			print "pkt_ctl[",j,"] = 3",";",
			tmp = "pkt_data["+str(j)+"] ='h"+reverse1(line[64*2*(i):])+";"
			print tmp,
			j = j+1





	
	
